import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'month.dart';

part 'year.g.dart';

@HiveType(typeId: 0)
class Year extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late int year;

  @HiveField(2)
  late HiveList<Month> months;

  // Constructeur vide pour l'usage exclusif de Hive
  Year();

  // Factory pour créer de nouvelles instances
  factory Year.create({required int year}) {
    final newYear = Year()
      ..id = const Uuid().v4()
      ..year = year
      ..months = HiveList(Hive.box<Month>('months'));
    return newYear;
  }
}
