# Mandatory Cross-Project Git Delivery (2026-09-29)

所有實作、修復、文件、原型、技能與 Wiki 倉庫變更均須遵守 [跨專案 Git 交付規範](https://github.com/chevalier1216/KarpathyWiki_personal/blob/main/CROSS_PROJECT_GIT_POLICY.md)；不得 direct commit/push 預設整合分支（既有 main/master，或正式切換前的當前 default）。專案個別規格、驗證、授權、費用防護不變；如與舊的 direct-to-main 指示衝突，以此政策為準。

1. 先讀最新整合分支，獨立任務建立 `feat/*` / `fix/*` / `docs/*` / `chore/*` 短期 branch；同時開發不同功能則獨立 branch、PR 及必要的隔離工作樹。
2. 在 branch 修改 → 執行適當測試/文件連結檢查與敏感資訊掃描 → commit → push branch → GitHub Pull Request（PR / Merge Request），關聯相關 Issue。
3. PR 須有目的/範圍、測試及 CI 證據、相依項、風險、資料或 migration/部署與回檔方案；CI 未過、衝突未解或重大風險未審查不得 merge。
4. 預設 Squash Merge 到受保護整合分支；部署者在合併後確認正式結果。回報 Base、Branch、PR URL、Head SHA、CI、Merge SHA、Deploy/Readback、Revert 方法；PR pending 就標 pending，不能宣稱完成。
5. 回檔透過新 `revert/*` 分支與 PR，絕不 force push/reset 整合分支；外部資料/DB/附件需另外的可行回復措施。
6. 禁止因 Agent、Codex/Work 額度、工具限制、緊急修正而自行繞過 PR。僅使用者對單次例外明確核准才可考慮；GitHub Ruleset 應另設定 Require PR / Required checks / Block force push/deletion 並讀回，文件本身不等於保護已啟用。

使用者無須每次重述這些工作流規則；由執行 Agent 自動遵守。

---

# AI 研究工作區規範

## 目標

以可稽核的證據研究面向終端消費者的 AI 賦能機會，供產品負責人轉化為後續驗證實驗。現行範圍包含家戶食材選購、合適就醫服務導引，以及其他未被滿足的消費服務需求。

## 必經工作流程

1. 定義研究命題、市場與時間邊界、欲回答的問題及報告驗收條件。
2. 由獨立角色分別負責證據蒐集、來源驗證、分析、審核與編輯。
3. 原始證據存放於檔案；階段交接僅保留標準化的結論摘要。
4. 事實、推論與建議必須明確分開。
5. 每份報告均應附精簡的 4W（誰、做了什麼、何處、何時）進度更新。
6. 連續兩次研究嘗試未取得實質進展，或下一步將改變研究範圍時，停止迴圈，說明阻礙、已嘗試方法及需由使用者決定的最小事項。

## 證據規範

- 每一項事實主張均需附原始網頁或 PDF、發布單位、發布／存取日期，以及支持該主張的段落或位置。
- 影響結論的主張，能取得時應以兩個獨立來源交叉驗證。
- 無法取得、互相矛盾、僅單一來源、資料過期或未驗證的內容，必須明顯標示，不得成為核心結論。
- 醫療研究僅限服務流程與資源協調；不得提供診斷、治療、緊急程度判斷或就醫指示。
- 競品研究順序為臺灣、中國大陸、其他亞太市場。海外功能不得直接外推為臺灣的需求、法規、價格或可行性。

## 檔案位置

- `research-harness/`：工作規格、範本、工具登錄、來源紀錄及報告。
- `research-harness/templates/`：新報告與進度更新範本。
- `research-harness/evidence/`：來源與主張紀錄。
- `research-harness/reports/`：已完成審核的報告。

## 工具導入

導入 GitHub 工具前，應評估維護者、授權條款、近期維護狀態、安全性、資料處理方式、授權範圍、可重現性與回復方式。版本應固定；未完成範圍審核前，不得讓外部爬蟲存取已登入的服務。
