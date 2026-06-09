import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'en': {
      'appTitle': 'Professional CV Builder',
      'myResumes': 'My Resumes',
      'noResumes': 'No resumes yet',
      'createFirstCV': 'Create your first professional CV now!',
      'createNewCV': 'CREATE NEW CV',
      'recentDocuments': 'RECENT DOCUMENTS',
      'lastUpdated': 'Last updated',
      'edit': 'Edit',
      'delete': 'Delete',
      'exportBackup': 'Export Backup',
      'importBackup': 'Import Backup',
      'backupRestored': 'Backup restored successfully',
      'backupFailed': 'Failed to restore backup: Invalid format',
      'getStarted': 'GET STARTED',
      'onboardingDesc': 'Create professional, high-quality resumes in minutes. Better than Europass, and completely free.',
      'freeAccess': '100% Free Access',
      'professionalTemplates': 'Professional PDF Templates',
      'easySecure': 'Easy to use & Secure',
      'personal': 'PERSONAL',
      'experience': 'EXPERIENCE',
      'education': 'EDUCATION',
      'skills': 'SKILLS'
    },
    'es': {
      'appTitle': 'Constructor de CV Profesional',
      'myResumes': 'Mis Currículums',
      'noResumes': 'Aún no hay currículums',
      'createFirstCV': '¡Crea tu primer CV profesional ahora!',
      'createNewCV': 'CREAR NUEVO CV',
      'recentDocuments': 'DOCUMENTOS RECIENTES',
      'lastUpdated': 'Última actualización',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'exportBackup': 'Exportar Respaldo',
      'importBackup': 'Importar Respaldo',
      'backupRestored': 'Respaldo restaurado con éxito',
      'backupFailed': 'Fallo al restaurar el respaldo: Formato inválido',
      'getStarted': 'COMENZAR',
      'onboardingDesc': 'Crea currículums profesionales de alta calidad en minutos. Mejor que Europass y completamente gratis.',
      'freeAccess': 'Acceso 100% gratuito',
      'professionalTemplates': 'Plantillas PDF Profesionales',
      'easySecure': 'Fácil de usar y Seguro',
      'personal': 'PERSONAL',
      'experience': 'EXPERIENCIA',
      'education': 'EDUCACIÓN',
      'skills': 'HABILIDADES'
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
