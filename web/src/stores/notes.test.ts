import {setActivePinia, createPinia} from "pinia";
import {expect, describe, beforeEach, it, vi} from "vitest";
import NotesRequests, {Note} from "@/api/resources/notes";
import moment from "moment";
import {useNotesStore} from "@/stores/notes";

describe("notes Store", () => {
  const notes: Note[] = [
    {
      id: "1",
      type: "notes",
      links: {
        self: "self_url",
      },
      attributes: {
        title: "Example title",
        description: "Example description",
        month: 1,
        year: 2024,
      },
    }
  ];

  beforeEach(() => {
    setActivePinia(createPinia());
  });

  describe("fetchAll", () => {
    it("fills notes", async () => {
      vi.spyOn(NotesRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Note[]>(notes)
      );

      const store = useNotesStore();
      expect(store.notes).toStrictEqual([]);
      await store.fetchAll(moment());
      expect(store.notes).toStrictEqual(notes);
    });
  });
});
