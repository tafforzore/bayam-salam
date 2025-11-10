import 'package:bayamsalam/domain/core/entities/month.dart';
import 'package:bayamsalam/domain/core/entities/year.dart';
import 'package:hive/hive.dart';

class MonthStore {

  /// Tente de trouver un mois dans une année donnée, et le crée s'il n'existe pas.
  /// C'est la fonction la plus critique pour la gestion des relations.
  Future<Month> getOrCreateInYear(Year year, String monthName) async {
    try {
      // Cherche un mois existant dans la liste de l'année.
      // Si ça réussit, c'est que la relation existe déjà. On retourne le mois.
      return year.months.firstWhere((m) => m.name == monthName);
    } catch (e) {
      // Le mois n'existe pas dans la liste de l'année. Il faut le créer et le lier.
      
      // 1. Créer le nouvel objet "enfant" en mémoire.
      final newMonth = Month.create(name: monthName);

      // 2. Le sauvegarder dans sa propre boîte pour le rendre "officiel" et géré par Hive.
      final monthBox = Hive.box<Month>('months');
      await monthBox.put(newMonth.id, newMonth);

      // 3. Maintenant que l'enfant est officiel, on peut l'ajouter à la liste du parent.
      year.months.add(newMonth);

      // 4. On sauvegarde le parent pour que Hive enregistre la nouvelle relation.
      await year.save();

      return newMonth;
    }
  }
}
