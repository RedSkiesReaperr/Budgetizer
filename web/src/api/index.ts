import AuthRequests from "@/api/resources/auth";
import BudgetsRequests from "@/api/resources/budgets";
import CategoriesRequests from "@/api/resources/categories";
import LinesRequests from "@/api/resources/lines";
import NotesRequests from "@/api/resources/notes";
import OperationsRequests from "@/api/resources/operations";

export default {
  auth: AuthRequests,
  budgets: BudgetsRequests,
  categories: CategoriesRequests,
  lines: LinesRequests,
  notes: NotesRequests,
  operations: OperationsRequests,
};
