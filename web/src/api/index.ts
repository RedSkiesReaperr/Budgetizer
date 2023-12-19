import AuthRequests from "@/api/resources/auth";
import BudgetsRequests from "@/api/resources/budgets";
import OperationsRequests from "@/api/resources/operations";
import LinesRequests from "@/api/resources/lines";
import NotesRequests from "@/api/resources/notes";

export default {
  auth: AuthRequests,
  budgets: BudgetsRequests,
  operations: OperationsRequests,
  lines: LinesRequests,
  notes: NotesRequests,
};
