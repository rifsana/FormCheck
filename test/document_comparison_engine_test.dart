import 'package:flutter_test/flutter_test.dart';
import 'package:form_check/features/comparison/domain/comparison_result.dart';
import 'package:form_check/features/comparison/domain/date_parsing_util.dart';
import 'package:form_check/features/comparison/domain/document_comparison_engine.dart';
import 'package:form_check/features/comparison/domain/document_field.dart';

void main() {
  group('DateParsingUtil Tests', () {
    test('Parses standard Indian DD/MM/YYYY formats', () {
      final res = DateParsingUtil.parseDate('15/08/1995');
      expect(res.isSuccess, isTrue);
      expect(res.date, equals(DateTime(1995, 8, 15)));
      expect(res.standardizedString, equals('15/08/1995'));
    });

    test('Parses hyphen-delimited DD-MM-YYYY format', () {
      final res = DateParsingUtil.parseDate('26-01-1990');
      expect(res.isSuccess, isTrue);
      expect(res.date, equals(DateTime(1990, 1, 26)));
      expect(res.standardizedString, equals('26/01/1990'));
    });

    test('Parses dot-delimited DD.MM.YYYY format', () {
      final res = DateParsingUtil.parseDate('02.10.1985');
      expect(res.isSuccess, isTrue);
      expect(res.date, equals(DateTime(1985, 10, 2)));
    });

    test('Parses ISO YYYY-MM-DD format', () {
      final res = DateParsingUtil.parseDate('1992-12-25');
      expect(res.isSuccess, isTrue);
      expect(res.date, equals(DateTime(1992, 12, 25)));
      expect(res.standardizedString, equals('25/12/1992'));
    });

    test(
      'Parses textual month format ("15 Aug 1995" and "15 August 1995")',
      () {
        final res1 = DateParsingUtil.parseDate('15 Aug 1995');
        expect(res1.isSuccess, isTrue);
        expect(res1.date, equals(DateTime(1995, 8, 15)));

        final res2 = DateParsingUtil.parseDate('15 August 1995');
        expect(res2.isSuccess, isTrue);
        expect(res2.date, equals(DateTime(1995, 8, 15)));
      },
    );

    test('Identifies Year of Birth only (Aadhaar YOB limitation)', () {
      final res1 = DateParsingUtil.parseDate('1995');
      expect(res1.isSuccess, isFalse);
      expect(res1.isYearOnly, isTrue);
      expect(res1.year, equals(1995));

      final res2 = DateParsingUtil.parseDate('Year of Birth: 1988');
      expect(res2.isSuccess, isFalse);
      expect(res2.isYearOnly, isTrue);
      expect(res2.year, equals(1988));
    });

    test('Rejects invalid calendar dates (overflow prevention)', () {
      final res = DateParsingUtil.parseDate('31/02/1995');
      expect(res.isSuccess, isFalse);
      expect(res.failureReason, contains('Invalid calendar date'));
    });

    test('Handles null and empty inputs safely', () {
      expect(DateParsingUtil.parseDate(null).isSuccess, isFalse);
      expect(DateParsingUtil.parseDate('').isSuccess, isFalse);
      expect(DateParsingUtil.parseDate('   ').isSuccess, isFalse);
    });
  });

  group('DocumentComparisonEngine — Full Name Comparisons', () {
    test('Exact match for identical names', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.exactMatch));
      expect(result.isMatch, isTrue);
      expect(result.requiresApplicantAttention, isFalse);
    });

    test('Normalized match for case and internal whitespace variations', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: '  RAHUL   SHARMA  ',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.normalizedMatch));
      expect(result.isMatch, isTrue);
      expect(result.flaggedNotes, isNotEmpty);
    });

    test('Flags possible mismatch for different spelling', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Seeta Devi',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Sita Devi',
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.possibleMismatch));
      expect(result.isMatch, isFalse);
      expect(result.requiresApplicantAttention, isTrue);
      expect(result.summary, contains('Possible name difference'));
    });

    test('Flags possible mismatch for additional middle name token', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Kumar Sharma',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.possibleMismatch));
      expect(result.flaggedNotes.any((n) => n.contains('Kumar')), isTrue);
    });

    test('Flags possible mismatch for word order differences', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Sharma Rahul',
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.possibleMismatch));
      expect(result.summary, contains('Word order difference'));
    });

    test(
      'Flags possible mismatch when initials or abbreviations are present',
      () {
        const a = DocumentField(
          documentType: DocumentType.aadhaar,
          fieldType: ComparisonFieldType.fullName,
          rawValue: 'R. Sharma',
        );
        const b = DocumentField(
          documentType: DocumentType.panCard,
          fieldType: ComparisonFieldType.fullName,
          rawValue: 'Rahul Sharma',
        );

        final result = DocumentComparisonEngine.compareFullNames(a, b);
        expect(result.status, equals(FieldMatchStatus.possibleMismatch));
        expect(result.flaggedNotes.any((n) => n.contains('initials')), isTrue);
      },
    );

    test('Requires manual review when extraction confidence is low', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
        confidence: 0.45,
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
        confidence: 0.95,
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.manualReviewRequired));
      expect(result.requiresApplicantAttention, isTrue);
      expect(result.summary, contains('Low extraction clarity'));
    });

    test('Identifies missing name field on one or both documents', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.fullName,
        rawValue: null,
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: 'Rahul Sharma',
      );

      final result = DocumentComparisonEngine.compareFullNames(a, b);
      expect(result.status, equals(FieldMatchStatus.missingField));
      expect(result.summary, contains('Name missing on Aadhaar Card'));

      const emptyBoth = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.fullName,
        rawValue: '   ',
      );
      final resultBoth = DocumentComparisonEngine.compareFullNames(
        a,
        emptyBoth,
      );
      expect(resultBoth.status, equals(FieldMatchStatus.missingField));
      expect(resultBoth.summary, contains('missing in both'));
    });
  });

  group('DocumentComparisonEngine — Date of Birth Comparisons', () {
    test('Exact match for identical date strings', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );

      final result = DocumentComparisonEngine.compareDatesOfBirth(a, b);
      expect(result.status, equals(FieldMatchStatus.exactMatch));
      expect(result.isMatch, isTrue);
    });

    test('Normalized match for same calendar date in different formats', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15-Aug-1995',
      );

      final result = DocumentComparisonEngine.compareDatesOfBirth(a, b);
      expect(result.status, equals(FieldMatchStatus.normalizedMatch));
      expect(result.isMatch, isTrue);
      expect(result.summary, contains('Dates of birth match (15/08/1995)'));
    });

    test('Flags possible mismatch for different calendar dates', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '16/08/1995',
      );

      final result = DocumentComparisonEngine.compareDatesOfBirth(a, b);
      expect(result.status, equals(FieldMatchStatus.possibleMismatch));
      expect(result.isMatch, isFalse);
      expect(result.summary, contains('mismatch detected'));
    });

    test('Requires manual review when one document only has Year of Birth', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '1995',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );

      final result = DocumentComparisonEngine.compareDatesOfBirth(a, b);
      expect(result.status, equals(FieldMatchStatus.manualReviewRequired));
      expect(result.summary, contains('Year of Birth only'));
      expect(
        result.flaggedNotes.any((n) => n.contains('Aadhaar Card')),
        isTrue,
      );
    });

    test('Requires manual review for unparseable date strings', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: 'gibberish_date',
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );

      final result = DocumentComparisonEngine.compareDatesOfBirth(a, b);
      expect(result.status, equals(FieldMatchStatus.manualReviewRequired));
      expect(result.summary, contains('could not be verified'));
    });

    test('Handles missing date of birth field', () {
      const a = DocumentField(
        documentType: DocumentType.aadhaar,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: null,
      );
      const b = DocumentField(
        documentType: DocumentType.panCard,
        fieldType: ComparisonFieldType.dateOfBirth,
        rawValue: '15/08/1995',
      );

      final result = DocumentComparisonEngine.compareDatesOfBirth(a, b);
      expect(result.status, equals(FieldMatchStatus.missingField));
    });
  });

  group('DocumentComparisonEngine — Document Report Aggregation', () {
    test('Produces aggregated report for Aadhaar vs PAN Card', () {
      final docA = [
        const DocumentField(
          documentType: DocumentType.aadhaar,
          fieldType: ComparisonFieldType.fullName,
          rawValue: 'Rahul Sharma',
        ),
        const DocumentField(
          documentType: DocumentType.aadhaar,
          fieldType: ComparisonFieldType.dateOfBirth,
          rawValue: '15/08/1995',
        ),
      ];

      final docB = [
        const DocumentField(
          documentType: DocumentType.panCard,
          fieldType: ComparisonFieldType.fullName,
          rawValue: 'RAHUL SHARMA',
        ),
        const DocumentField(
          documentType: DocumentType.panCard,
          fieldType: ComparisonFieldType.dateOfBirth,
          rawValue: '15-08-1995',
        ),
      ];

      final report = DocumentComparisonEngine.compareDocuments(
        baseDocType: DocumentType.aadhaar,
        targetDocType: DocumentType.panCard,
        baseFields: docA,
        targetFields: docB,
      );

      expect(report.baseDocumentType, equals(DocumentType.aadhaar));
      expect(report.targetDocumentType, equals(DocumentType.panCard));
      expect(report.fieldResults.length, equals(2));
      expect(report.isAllMatching, isTrue);
      expect(report.hasMismatches, isFalse);
      expect(report.matchCount, equals(2));
    });

    test('Flags document report with mismatch and missing field', () {
      final docA = [
        const DocumentField(
          documentType: DocumentType.aadhaar,
          fieldType: ComparisonFieldType.fullName,
          rawValue: 'Rahul Sharma',
        ),
        const DocumentField(
          documentType: DocumentType.aadhaar,
          fieldType: ComparisonFieldType.dateOfBirth,
          rawValue: '15/08/1995',
        ),
      ];

      final docB = [
        const DocumentField(
          documentType: DocumentType.panCard,
          fieldType: ComparisonFieldType.fullName,
          rawValue: 'Rohit Sharma', // Mismatch
        ),
        // Date of birth missing in PAN
      ];

      final report = DocumentComparisonEngine.compareDocuments(
        baseDocType: DocumentType.aadhaar,
        targetDocType: DocumentType.panCard,
        baseFields: docA,
        targetFields: docB,
      );

      expect(report.hasMismatches, isTrue);
      expect(report.hasMissingFields, isTrue);
      expect(report.isAllMatching, isFalse);
      expect(report.mismatchCount, equals(1));
    });
  });
}
