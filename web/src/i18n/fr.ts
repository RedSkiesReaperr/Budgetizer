export default {
  10: '10',
  25: '25',
  50: '50',
  100: '100',
  locales: {
    fr: "Français",
    en: "Anglais",
  },
  earning: "Revenu | Revenus",
  expense: "Dépense | Dépenses",
  overview: "Vue d'ensemble",
  forecast: "Prévision | Prévisions",
  category: "Catégorie | Catégories",
  action: "Action | Actions",
  saving: "Economie | Economies",
  information: "Information | Informations",
  no_data: "Pas de données à afficher",
  dashboard: {
    appbar: {
      logout: "Se déconnecter",
    },
    sidebar: {
      general: "Général",
    },
    attributes: {
      id: "ID",
      name: "Nom",
    },
  },
  operation: {
    attributes: {
      id: "ID",
      date: "Date",
      label: "Intitulé",
      type: "Type",
      category: "Catégorie",
      amount: "Montant",
      comment: "Note",
      pointed: "Pointé",
    },
    types: {
      vital: "Vital",
      non_essential: "Non essentiel",
      income: "Revenu",
      unknown: "Inconnu",
    },
    categories: {
      unknown: "Catégorie inconnue",
      to_categorize: "A catégoriser",
      home: "Logement",
      bank: "Banque",
      shopping: "Shopping",
      food: "Alimentation",
      subscriptions: "Abonnements",
      auto_transport: "Auto & Transports",
      beauty_care: "Beauté & Soins",
      taxes: "Taxes",
      salary: "Salaire",
    },
    edition: {
      title: "Editer une opération",
      error: "Erreur lors de l'édition",
      success_title: "Opération mise à jour !",
      success_message: "Les informations de l'opération ont été mises à jour",
    },
    import: {
      action: "Importer des opérations",
      success_title: "Import réussi",
      success_message: "Toutes les opération ont été importées avec succès",
      error_title: "Erreur lors de l'importation",
    }
  },
  line: {
    attributes: {
      id: "ID",
      label: "Intitulé",
      type: "Type",
      amount: "Montant",
    },
    edition: {
      title: "Editer une ligne de dashboard",
      error: "Erreur lors de l'édition",
      success_title: "Ligne éditée",
      success_message: "La ligne a mise à jour avec succès !",
    },
    creation: {
      title: "Créer une ligne",
      error: "Erreur lors de la création",
      success_title: "Ligne créée",
      success_message: "La ligne a été créée avec succès !",
    },
    deletion: {
      title: "Confirmer la suppression ?",
      body: "Si vous confirmez la suppression, les informations de cette ligne de dashboard ne pourront plus être récupérées.",
    },
  },
  forecast_page: {
    card_info:
      "L'objectif budgetaire pour le type '{type}' est de {budgetTargetAmount}€. Les prévisions sont de {valueAmount}€. Cela représente une différence de {diffValue}€, soit {diffPercentage}.",
  },
  form_validations: {
    required: "est obligatoire",
    gt: "doit être supérieur à {limit}",
    category: {
      key: {
        invalid_format: "ne doit comporter que des lettres minuscules ou des _"
      }
    }
  },
  actions: {
    cancel: "Annuler",
    create: "Créer",
    save: "Sauvegarder",
    delete: "Supprimer",
    select: "Sélectionner",
    login: "Se connecter",
    select_file: "Sélectionner un fichier",
    confirm: "Confirmer"
  },
  email: "Adresse email",
  password: "Mot de passe",
  login: {
    error_title: "Nous n'avons pas pu vous connecter",
  },
  something_went_wrong: "Oups! Quelque chose s'est mal passé.",
  note: "Note | Notes",
  no_note: "Aucune note disponible",
  color: "Couleur | Couleurs",
  icon: "Icone | Icones",
  404: {
    title: "Page introuvable",
    text: "Nous ne savons pas ce que vous recherchiez mais cela n'existe pas.",
    button: "Revenir en lieu sûr",
  },
  resource: {
    category: {
      attributes: {
        id: "ID",
        key: "Clé",
        color: "Couleur",
        icon: "Icone",
      },
      deletion: {
        title: "Confirmer la suppression ?",
        subtitle: "Si vous confirmez la suppression, toutes les ressources lieés à cette catégorie seront auront le status \"à catégoriser\".",
        error: "Erreur lors de la suppression",
        success_title: "Catégorie supprimée !",
        success_message: "La catégorie a été supprimée",
      },
      creation: {
        action: "Créer une catégorie",
        title: "Nouvelle catégorie",
        error: "Erreur lors de la création",
        success_title: "Catégorie créée !",
        success_message: "La catégorie a été créée",
      },
      edition: {
        action: "Editer une catégorie",
        title: "Edition d'une catégorie",
        error: "Erreur lors de l'édition",
        success_title: "Catégorie modifiée !",
        success_message: "La catégorie a été mise à jour",
      }
    }
  },
  charts: {
    income_breakdown: "Répartition des revenus",
    expense_breakdown: "Répartition des dépenses",
    overall_breakdown: "Répartition générale",
  },
  operations_categorize_card: {
    all_categorized: "Toutes les opérations sont catégorisées !",
    some_uncategorized: "Opération(s) à catégoriser",
  }
};
