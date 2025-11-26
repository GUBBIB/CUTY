import { useMemo, useState, useEffect } from "react";
import "./SearchSelectDialog.css";

export interface OptionItem {
  id: number;
  label: string;
  eng_name: string | null;
}

interface SearchSelectDialogProps {
  label: string;
  placeholder?: string;
  valueLabel?: string | null;
  options: OptionItem[];
  onSelect: (option: OptionItem) => void;
}

const SearchSelectDialog = ({
  label,
  placeholder = "검색해서 선택하세요",
  valueLabel,
  options,
  onSelect,
}: SearchSelectDialogProps) => {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");

  const filteredOptions = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return options;
    return options.filter((opt) => opt.label.toLowerCase().includes(q));
  }, [options, query]);

  const handleSelect = (opt: OptionItem) => {
    onSelect(opt);
    setOpen(false);
    setQuery("");
  };

  useEffect(() => {
    if (!open) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        setOpen(false);
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [open]);

  return (
    <div className="search-select-field">
      <label className="search-select-label">{label}</label>
      <div
        className="search-select-trigger"
        onClick={() => setOpen(true)}
      >
        {valueLabel || placeholder}
      </div>

      {open && (
        <div className="search-select-overlay" onClick={() => setOpen(false)}>
          <div
            className="search-select-dialog"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="search-select-header">
              <div className="search-select-title">{label} 선택</div>
              <div
                className="search-select-close"
                onClick={() => setOpen(false)}
              >
                ✕
              </div>
            </div>

            <input
              type="text"
              className="search-select-input"
              placeholder="검색어를 입력하세요"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />

            <div className="search-select-list">
              {filteredOptions.length === 0 && (
                <div className="search-select-empty">검색 결과가 없습니다.</div>
              )}

              {filteredOptions.map((opt) => (
                <div
                  key={opt.id}
                  className="search-select-item"
                  onClick={() => handleSelect(opt)}
                >
                  {opt.label}
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default SearchSelectDialog;
