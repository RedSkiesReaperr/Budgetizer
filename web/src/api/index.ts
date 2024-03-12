import AuthRequests from "@/api/resources/auth";
import CategoriesRequests from "@/api/resources/categories";
import ForecastsRequests from "@/api/resources/forecasts";
import LinesRequests from "@/api/resources/lines";
import NotesRequests from "@/api/resources/notes";
import ObjectivesRequests from "@/api/resources/objectives";
import OperationsRequests from "@/api/resources/operations";

export default {
  auth: AuthRequests,
  categories: CategoriesRequests,
  forecasts: ForecastsRequests,
  lines: LinesRequests,
  notes: NotesRequests,
  objectives: ObjectivesRequests,
  operations: OperationsRequests,
};
