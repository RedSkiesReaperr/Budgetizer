export default {
  10: '10',
  25: '25',
  50: '50',
  100: '100',
  locales: {
    fr: "French",
    en: "English",
  },
  earning: "Earning | Earnings",
  expense: "Expense | Expenses",
  overview: "Overview",
  forecast: "Forecast | Forecasts",
  category: "Category | Categories",
  action: "Action | Actions",
  saving: "Saving | Savings",
  information: "Information | Informations",
  no_data: "No data to display",
  dashboard: {
    appbar: {
      logout: "Log out",
    },
    sidebar: {
      general: "General",
    },
    attributes: {
      id: "ID",
      name: "Name",
    },
  },
  operation: {
    attributes: {
      id: "ID",
      date: "Date",
      label: "Label",
      type: "Type",
      category: "Category",
      amount: "Amount",
      comment: "Comment",
      pointed: "Pointed",
    },
    types: {
      vital: "Vital",
      non_essential: "Non essential",
      income: "Income",
      unknown: "Unknown",
    },
    categories: {
      unknown: "Unknown category",
      to_categorize: "To categorize",
      home: "Home",
      bank: "Bank",
      shopping: "Shopping",
      food: "Food",
      subscriptions: "Subscriptions",
      auto_transport: "Auto & Transports",
      beauty_care: "Beauty & Care",
      taxes: "Taxes",
      salary: "Salary",
    },
    edition: {
      title: "Edit an operation",
      error: "Error while editing",
      success_title: "Operation successfully updated !",
      success_message: "Operation informations have been updated",
    },
    import: {
      action: "Import operations",
      success_title: "Import successfull",
      success_message: "All operations has been imported",
      error_title: "Import failed",
    }

  },
  line: {
    attributes: {
      id: "ID",
      label: "Label",
      type: "Type",
      amount: "Amount",
    },
    edition: {
      title: "Edit a dashboard line",
      error: "Error while editing",
    },
    creation: {
      title: "Create a line",
      error: "Error while creating",
    },
    deletion: {
      title: "Confirm deletion ?",
      body: "If you confirm the deletion informations about this dashboard line can no longer be retrieved.",
    },
  },
  forecast_page: {
    card_info:
      "Budget objective for '{type}' type is {budgetTargetAmount}€. The forecast is {valueAmount}€. This represents a difference of {diffValue}€ ({diffPercentage}).",
  },
  form_validations: {
    required: "is mandatory",
    gt: "must be greater than {limit}",
  },
  actions: {
    cancel: "Cancel",
    create: "Create",
    save: "Save",
    delete: "Delete",
    select: "Select",
    login: "Log in",
    select_file: "Select file",
    confirm: "Confirm"
  },
  email: "Email",
  password: "Password",
  login: {
    error_title: "We were unable to log you in",
  },
  something_went_wrong: "Oops! Something went wrong.",
  note: "Note | Notes",
  no_note: "No note available",
  color: "Color | Colors",
  icon: "Icon | Icons",
  404: {
    title: "Page not found",
    text: "We don't know what you were looking for, but it doesn't exist.",
    button: "Come back to a safe place",
  },
  resource: {
    category: {
      attributes: {
        id: "ID",
        key: "Key",
        color: "Color",
        icon: "Icon",
      },
      deletion: {
        title: "Confirm deletion ?",
        subtitle: "If you confirm deletion, all resources linked to this category will have status \"to cetegorize\".",
      }
    }
  }
};
