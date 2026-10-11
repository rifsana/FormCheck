import 'package:flutter_test/flutter_test.dart';
import 'package:form_check/features/scanner/domain/document_text_extractor.dart';
import 'package:form_check/features/scanner/domain/document_text_parser.dart';

void main() {
  group('DocumentTextParser — Base Heuristic Extraction', () {
    test(
      'Parses Aadhaar card text lines and extracts candidate name and DOB',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'GOVERNMENT OF INDIA',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: 'UNIQUE IDENTIFICATION AUTHORITY OF INDIA',
            confidence: null,
          ),
          const ExtractedTextLine(lineNumber: 3, text: 'To,', confidence: null),
          const ExtractedTextLine(
            lineNumber: 4,
            text: 'Rahul Sharma',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 5,
            text: 'DOB: 15/08/1995',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 6,
            text: 'Male',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 7,
            text: '9876 5432 1098',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.hasNameCandidate, isTrue);
        expect(result.candidateName?.detectedValue, equals('Rahul Sharma'));
        expect(result.hasDobCandidate, isTrue);
        expect(result.candidateDob?.detectedValue, equals('15/08/1995'));
        expect(result.candidateDob?.isAmbiguous, isFalse);
        expect(result.sensitiveIdentifierDetected, isTrue);
      },
    );

    test(
      'Ignores PAN card headers and preserves applicant name over father name',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'INCOME TAX DEPARTMENT',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: 'GOVT. OF INDIA',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 3,
            text: 'Priya Sharma',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 4,
            text: "Father's Name: Mohan Sharma",
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 5,
            text: '22/04/1992',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 6,
            text: 'ABCDE1234F',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.hasNameCandidate, isTrue);
        expect(result.candidateName?.detectedValue, equals('Priya Sharma'));
        expect(result.hasDobCandidate, isTrue);
        expect(result.candidateDob?.detectedValue, equals('22/04/1992'));
        expect(result.sensitiveIdentifierDetected, isTrue);
      },
    );
  });

  group('DocumentTextParser — Contextual Date & Multi-Date Handling', () {
    test(
      'Selects DOB and ignores Issue and Validity dates on Driving License',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'INDIAN UNION DRIVING LICENCE',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: 'Name: Amit Verma',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 3,
            text: 'Date of Issue: 10/01/2015',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 4,
            text: 'DOB: 05/11/1990',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 5,
            text: 'Valid Till: 04/11/2030',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.candidateDob?.detectedValue, equals('05/11/1990'));
        expect(result.candidateDob?.isAmbiguous, isFalse);
        expect(result.detectedDates, contains('10/01/2015'));
        expect(result.detectedDates, contains('04/11/2030'));
        expect(
          result.notes.any((n) => n.contains('Ignored date "10/01/2015"')),
          isTrue,
        );
        expect(
          result.notes.any((n) => n.contains('Ignored date "04/11/2030"')),
          isTrue,
        );
      },
    );

    test('Prefers explicitly labelled DOB candidate over unlabelled date on same document', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Rahul Sharma',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: 'DOB: 15/08/1995',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 3,
          text: '01/01/2021', // Unlabelled timestamp / generation date
          confidence: null,
        ),
      ];

      final result = DocumentTextParser.parse(lines);
      expect(result.hasDobCandidate, isTrue);
      expect(result.candidateDob?.detectedValue, equals('15/08/1995'));
      expect(result.candidateDob?.isAmbiguous, isFalse);
      expect(result.candidateDob?.alternates, contains('01/01/2021'));
    });

    test('Marks candidate DOB as ambiguous and does NOT select automatically when multiple unlabeled dates exist', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Rohan Gupta',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: '12/04/2018', // Unlabeled date 1
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 3,
          text: '15/08/1995', // Unlabeled date 2
          confidence: null,
        ),
      ];

      final result = DocumentTextParser.parse(lines);
      // Requirement: Do not select a DOB automatically when multiple candidates remain ambiguous
      expect(result.candidateDob, isNotNull);
      expect(result.candidateDob?.detectedValue, isNull);
      expect(result.hasDobCandidate, isFalse);
      expect(result.candidateDob?.isAmbiguous, isTrue);
      expect(result.candidateDob?.alternates, contains('12/04/2018'));
      expect(result.candidateDob?.alternates, contains('15/08/1995'));
      expect(
        result.notes.any((n) => n.contains('Multiple dates found')),
        isTrue,
      );
    });

    test('Detects Year of Birth only format and flags year-only property', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Suresh Kumar',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: 'Year of Birth: 1985',
          confidence: null,
        ),
      ];

      final result = DocumentTextParser.parse(lines);
      expect(result.hasDobCandidate, isTrue);
      expect(result.candidateDob?.detectedValue, equals('1985'));
      expect(result.candidateDob?.isYearOnly, isTrue);
      expect(
        result.notes.any((n) => n.contains('Year of birth (1985) detected')),
        isTrue,
      );
    });
  });

  group('DocumentTextParser — Regression Tests for Real-Device DOB Defect', () {
    test(
      'Handles DOB label and date separated across consecutive OCR lines',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'Rahul Sharma',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: 'DOB:', // Label on line 2
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 3,
            text: '15/08/1995', // Date on line 3
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 4,
            text: 'Date of Issue: 10/01/2020',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.hasDobCandidate, isTrue);
        expect(result.candidateDob?.detectedValue, equals('15/08/1995'));
        expect(result.candidateDob?.isAmbiguous, isFalse);
        expect(result.detectedDates, contains('10/01/2020'));
        expect(
          result.notes.any((n) => n.contains('Ignored date "10/01/2020"')),
          isTrue,
        );
      },
    );

    test(
      'Handles bilingual Devanagari/English DOB label separated across lines',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'Rahul Sharma',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: 'जन्म तारीख / DOB',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 3,
            text: '15/08/1995',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.hasDobCandidate, isTrue);
        expect(result.candidateDob?.detectedValue, equals('15/08/1995'));
        expect(result.candidateDob?.isAmbiguous, isFalse);
      },
    );

    test(
      'Handles separate lines for both Issue date and DOB without confusion',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'Date of Issue',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: '10/01/2015',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 3,
            text: 'Date of Birth',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 4,
            text: '15/08/1990',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 5,
            text: 'Valid Till',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 6,
            text: '09/01/2030',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.hasDobCandidate, isTrue);
        expect(result.candidateDob?.detectedValue, equals('15/08/1990'));
        expect(result.candidateDob?.isAmbiguous, isFalse);
        expect(result.detectedDates, contains('10/01/2015'));
        expect(result.detectedDates, contains('09/01/2030'));
        expect(
          result.notes.any((n) => n.contains('Ignored date "10/01/2015"')),
          isTrue,
        );
        expect(
          result.notes.any((n) => n.contains('Ignored date "09/01/2030"')),
          isTrue,
        );
      },
    );

    test('Handles multi-line Year of Birth on consecutive lines', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Rahul Sharma',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: 'Year of Birth',
          confidence: null,
        ),
        const ExtractedTextLine(lineNumber: 3, text: '1985', confidence: null),
      ];

      final result = DocumentTextParser.parse(lines);
      expect(result.hasDobCandidate, isTrue);
      expect(result.candidateDob?.detectedValue, equals('1985'));
      expect(result.candidateDob?.isYearOnly, isTrue);
      expect(result.candidateDob?.isAmbiguous, isFalse);
    });

    test('Handles Devanagari Year of Birth: जन्म वर्ष', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Rahul Sharma',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: 'जन्म वर्ष: 1985',
          confidence: null,
        ),
      ];

      final result = DocumentTextParser.parse(lines);
      expect(result.hasDobCandidate, isTrue);
      expect(result.candidateDob?.detectedValue, equals('1985'));
      expect(result.candidateDob?.isYearOnly, isTrue);
    });

    test(
      'Cleanly reports missing DOB when no dates are present on document',
      () {
        final lines = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'GOVERNMENT OF INDIA',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 2,
            text: 'Rahul Sharma',
            confidence: null,
          ),
          const ExtractedTextLine(
            lineNumber: 3,
            text: 'ABCDE1234F',
            confidence: null,
          ),
        ];

        final result = DocumentTextParser.parse(lines);
        expect(result.hasNameCandidate, isTrue);
        expect(result.hasDobCandidate, isFalse);
        expect(result.candidateDob, isNull);
        expect(result.detectedDates, isEmpty);
        expect(
          result.notes.any((n) => n.contains('No date of birth detected')),
          isTrue,
        );
      },
    );
  });

  group('DocumentTextParser — Diverse Indian Date Formats Support', () {
    test('Parses dates with OCR delimiter spacing variations', () {
      final linesSlash = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'DOB : 15 / 08 / 1995',
          confidence: null,
        ),
      ];
      final resSlash = DocumentTextParser.parse(linesSlash);
      expect(resSlash.candidateDob?.detectedValue, equals('15/08/1995'));

      final linesDash = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'DOB: 15 - 08 - 1995',
          confidence: null,
        ),
      ];
      final resDash = DocumentTextParser.parse(linesDash);
      expect(resDash.candidateDob?.detectedValue, equals('15/08/1995'));

      final linesDot = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'DOB: 15 . 08 . 1995',
          confidence: null,
        ),
      ];
      final resDot = DocumentTextParser.parse(linesDot);
      expect(resDot.candidateDob?.detectedValue, equals('15/08/1995'));
    });

    test(
      'Parses textual month date formats: 15 Aug 1995 and 15 August 1995',
      () {
        final linesShortMonth = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'Date of Birth: 15 Aug 1995',
            confidence: null,
          ),
        ];
        final resShort = DocumentTextParser.parse(linesShortMonth);
        expect(resShort.candidateDob?.detectedValue, equals('15/08/1995'));

        final linesFullMonth = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'DOB: 15 August 1995',
            confidence: null,
          ),
        ];
        final resFull = DocumentTextParser.parse(linesFullMonth);
        expect(resFull.candidateDob?.detectedValue, equals('15/08/1995'));
      },
    );

    test('Parses month-first date formats: August 15, 1995', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Date of Birth: August 15, 1995',
          confidence: null,
        ),
      ];
      final res = DocumentTextParser.parse(lines);
      expect(res.candidateDob?.detectedValue, equals('15/08/1995'));
    });

    test('Parses ISO date format: 1995-08-15', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'DOB: 1995-08-15',
          confidence: null,
        ),
      ];
      final res = DocumentTextParser.parse(lines);
      expect(res.candidateDob?.detectedValue, equals('15/08/1995'));
    });
  });

  group('DocumentTextParser — Confidence and Missing Field Handling', () {
    test('Represents confidence as unavailable when OCR engine does not provide it', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Name: Rajesh Patel',
          confidence: null, // No fabricated score
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: 'DOB: 10/10/1988',
          confidence: null,
        ),
      ];

      final result = DocumentTextParser.parse(lines);
      expect(result.candidateName?.confidence, isNull);
      expect(result.candidateName?.isConfidenceAvailable, isFalse);
      expect(result.candidateDob?.confidence, isNull);
      expect(result.candidateDob?.isConfidenceAvailable, isFalse);
      expect(result.requiresManualReview, isTrue);
    });

    test(
      'Handles missing fields cleanly when document text lacks name or date',
      () {
        final linesOnlyName = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'Kavita Sundaram',
            confidence: null,
          ),
        ];

        final resultOnlyName = DocumentTextParser.parse(linesOnlyName);
        expect(resultOnlyName.hasNameCandidate, isTrue);
        expect(resultOnlyName.hasDobCandidate, isFalse);

        final linesOnlyDob = [
          const ExtractedTextLine(
            lineNumber: 1,
            text: 'DOB: 01/01/1999',
            confidence: null,
          ),
        ];

        final resultOnlyDob = DocumentTextParser.parse(linesOnlyDob);
        expect(resultOnlyDob.hasNameCandidate, isFalse);
        expect(resultOnlyDob.hasDobCandidate, isTrue);
      },
    );

    test('Handles multiple plausible name lines with alternates', () {
      final lines = [
        const ExtractedTextLine(
          lineNumber: 1,
          text: 'Plausible Name One',
          confidence: null,
        ),
        const ExtractedTextLine(
          lineNumber: 2,
          text: 'Plausible Name Two',
          confidence: null,
        ),
      ];

      final result = DocumentTextParser.parse(lines);
      expect(result.hasNameCandidate, isTrue);
      expect(result.candidateName?.isAmbiguous, isTrue);
      expect(result.candidateName?.alternates, contains('Plausible Name Two'));
    });
  });
}
