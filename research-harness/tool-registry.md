# 工具導入登錄

| 工具 | 用途 | 授權 | 證據 | 狀態與理由 |
|---|---|---|---|---|
| Codex multi-agent 協作 | 分工、結論交接、獨立驗證 | 內建 | 本工作區已可用 | 啟用；作為主要 orchestrator，不另引入平行 agent 框架 |
| Google Drive / Docs connector | 產出與驗證 Google 文件 | 內建 | 本工作區已可用 | 啟用；保留原生文件與讀回驗證 |
| OpenAI Agents SDK | 需要自建 Python research service 時的 handoff/trace/guardrail | MIT | [GitHub](https://github.com/openai/openai-agents-python) | 待導入；僅在需獨立服務時採用，避免與現有協作機制重疊 |
| Trafilatura | 靜態網頁正文與中繼資料擷取 | Apache-2.0 | [GitHub](https://github.com/adbar/trafilatura) | 待隔離試用；適合建立可追溯證據包 |
| MarkItDown | PDF、Office、HTML 轉 Markdown | MIT | [GitHub](https://github.com/microsoft/markitdown) | 待隔離試用；原始檔與雜湊須保留 |
| GROBID | 論文 PDF 結構化與書目擷取 | Apache-2.0 | [GitHub](https://github.com/grobidOrg/grobid) | 待導入；僅在學術 PDF 成為主要來源時啟用 |
| Crawl4AI | 動態網頁擷取 | Apache-2.0（含署名要求） | [GitHub](https://github.com/unclecode/crawl4ai) | 觀察；近期曾有 RCE/SSRF 修補，僅可在無憑證隔離環境、固定版本與安全測試後使用 |
| Zotero | 人工審核來源庫與引用管理 | AGPL-3.0 | [GitHub](https://github.com/zotero) | 觀察；可作獨立桌面工具，不嵌入或改造成網路服務 |

## 導入前檢核

每項工具都要記錄版本／commit、依賴掃描、資料外送與帳號權限、測試範圍、回滾方法與責任人。高星數或大量使用不是安全性或真實性的證明。
