# 工具導入登錄

| 工具 | 用途 | 授權 | 證據 | 狀態與理由 |
|---|---|---|---|---|
| Codex multi-agent 協作 | 分工、結論交接、獨立驗證 | 內建 | 本工作區已可用 | 啟用；作為主要 orchestrator，不另引入平行 agent 框架 |
| Google Drive / Docs connector | 產出與驗證 Google 文件 | 內建 | 本工作區已可用 | 啟用；保留原生文件與讀回驗證 |
| Superpowers | 規劃、平行工作分派、隔離工作目錄、系統化除錯與完成前驗證 | 內建插件 | `superpowers` 技能清單與治理規格 | **啟用**；僅使用與研究階段相符的子技能。不得取代一手來源驗證、跨市場外推限制或醫療責任邊界；完整對照見「研究代理治理規格」技能使用矩陣。 |
| OpenAI Agents SDK | 需要自建 Python research service 時的 handoff/trace/guardrail | MIT | [GitHub](https://github.com/openai/openai-agents-python) | 待導入；僅在需獨立服務時採用，避免與現有協作機制重疊 |
| Trafilatura | 靜態網頁正文與中繼資料擷取 | Apache-2.0 | [GitHub](https://github.com/adbar/trafilatura) | 待隔離試用；適合建立可追溯證據包 |
| MarkItDown | PDF、Office、HTML 轉 Markdown | MIT | [GitHub](https://github.com/microsoft/markitdown) | 待隔離試用；原始檔與雜湊須保留 |
| GROBID | 論文 PDF 結構化與書目擷取 | Apache-2.0 | [GitHub](https://github.com/grobidOrg/grobid) | 待導入；僅在學術 PDF 成為主要來源時啟用 |
| Crawl4AI | 動態網頁擷取 | Apache-2.0（含署名要求） | [GitHub](https://github.com/unclecode/crawl4ai) | 觀察；近期曾有 RCE/SSRF 修補，僅可在無憑證隔離環境、固定版本與安全測試後使用 |
| Zotero | 人工審核來源庫與引用管理 | AGPL-3.0 | [GitHub](https://github.com/zotero) | 觀察；可作獨立桌面工具，不嵌入或改造成網路服務 |
| `lingzhi227/agent-research-skills@self-review` | 三角色自評與後設審核 | 授權未明 | [GitHub](https://github.com/lingzhi227/agent-research-skills) | **已於隔離目錄測試，未升級為全域技能**；依使用者核准固定 commit `9e6c085d65e313e475e921fdfe795ac11eb7589e` 下載並靜態檢查。功能限定學術論文的 NeurIPS 式 PDF／TeX 評審，與消費市場案例研究不相符；不執行其腳本、不安裝其可選 Python 依賴，也不以此技能取代研究證據審核。 |
| `wshobson/agents@llm-evaluation` | LLM 應用的度量、基準與評估策略 | MIT | [GitHub](https://github.com/wshobson/agents) | 未導入；38.5k stars，公開搜尋未找到與該技能直接相關的惡意程式或漏洞報告，但它偏向 LLM 應用評測，無法取代目前的研究流程治理，且整體市集規模大，不符合最小導入原則。 |
| `mlflow/skills@agent-evaluation` | Agent trace、評估與回歸監測 | Apache-2.0 | [GitHub](https://github.com/mlflow/mlflow) | 未導入；27.4k stars，公開搜尋未找到與該技能直接相關的惡意程式或漏洞報告。需 MLflow 追蹤與伺服器等基礎設施，僅在未來有自建 agent 應用與可量測 trace 時重新評估。 |

## 導入前檢核

每項工具都要記錄版本／commit、依賴掃描、資料外送與帳號權限、測試範圍、回滾方法與責任人。高星數或大量使用不是安全性或真實性的證明。

查核限制：上述「未找到」只代表本次公開搜尋未取得直接風險報告；GitHub 公開 API 在查核當日已達匿名速率上限，並不構成無漏洞或無惡意程式的保證。
