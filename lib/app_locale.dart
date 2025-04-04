import 'package:flutter_localization/flutter_localization.dart';

class AppLocale {
  static const String textOne = "textOne";
  static const String textTwo = "textTwo";
  static const String textThree = "textThree";
  static const String textFour = "textFour";
  static const String textFive = "textFive";
  static const String textSix = "textSix";
  static const String textSeven = "textSeven";
  static const String textEight = "textEight";
  static const String textAjTache = "textAjTache";
  static const String textNomTache = "textNomTache";
  static const String textDate = "textDate";
  static const String textModifier = "textModifier";
  static const String textAnnuler = "textAnnuler";
  static const String textEnregistrer = "textEnregistrer";
  static const String textSupprimer = "textSupprimer";
  static const String textSelection = "textSelection";

  static const Map<String, dynamic> EN = {
    textOne: "Settings",
    textTwo: "Theme",
    textThree: "Set dark mode",
    textFour: "Language",
    textFive: "French",
    textSix: "English",
    textSeven: "Notifications",
    textEight: "Save",

    textAjTache: "Add a task :",
    textNomTache : "Task name",
    textDate : "To do for the",
    textModifier : "Edit task",
    textAnnuler : "Cancel",
    textEnregistrer : "Save",
    textSupprimer : "DeleteTask",
    textSelection : "Selected date : "
  };

  static const Map<String, dynamic> FR = {
    textOne: "Paramètres",
    textTwo: "Thème",
    textThree: "Activer le thème sombre",
    textFour: "Langue",
    textFive: "Français",
    textSix: "Anglais",
    textSeven: "Notifications",
    textEight: "Enregistrer",

    textAjTache: "Ajouter une tâche :",
    textNomTache : "Nom de la tâche",
    textDate : "A faire pour le ",
    textModifier : "Modifier la tâche",
    textAnnuler : "Annuler",
    textEnregistrer : "Enregistrer",
    textSupprimer : "Tâche supprimée",
    textSelection : "Date sélectionnée : "

  };
}
