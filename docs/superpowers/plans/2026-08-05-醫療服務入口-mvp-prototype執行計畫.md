# 醫療服務入口 MVP／Prototype 執行計畫

> **給執行者：** 使用 `superpowers:executing-plans` 逐項執行本計畫；每一項完成後回報可驗證產物。實作前不得擴大至真實醫療資料、臨床功能、正式預約或支付。

**目標：** 建立內部可操作的平台化行政服務入口 Prototype，驗證 AI 受控欄位整理、來源標示、使用者確認、透過 MCP／Adapter 模擬調用外部資源、模擬交接與可回溯狀態流程。

**架構：** Web 前端呈現固定情境；後端以受控 API／MCP Adapter 處理服務目錄與模擬交接。LLM 只輸出行政 schema。平台協調外部專業服務端的已授權工具，平台不提供醫療、篩檢或資源判定。資料以 fixture 和 mock server 保存；所有真實外部動作均停留在 Adapter 介面，不實際執行。

**技術建議：** TypeScript、React／Next.js、Zod 或 JSON Schema、MSW 或同類 mock server、Playwright、SQLite 或記憶體 fixture。模型服務採支援 JSON Schema／函式呼叫的 API。技術選型可在執行開始前依現有專案調整，且須維持本規格的安全界線。

---

## 執行前準備

### 工作包 0：建立安全基線與資料契約

**檔案：**
- 新增：`docs/product/medical-mvp/boundaries.md`
- 新增：`docs/product/medical-mvp/schemas/*.json`
- 新增：`docs/product/medical-mvp/state-machine.md`

**步驟：**
1. 將設計規格的包含／排除範圍與平台／服務端責任分界轉為可測試的限制清單。
2. 定義 `AdministrativeRequest`、`ServiceCard`、`HandoffDraft`、`HandoffEvent` schema。
3. 定義狀態轉換與禁止轉換；保留 `送出失敗` 回復路徑。
4. 為每個 schema 欄位標示資料分類、保存期限、是否可寫入日誌與資料責任方。

**驗證：** 建立 schema 單元測試；臨床欄位、真實健康資料欄位與真實預約 ID 必須被拒絕。

### 工作包 1：建立合成資料與受控 Adapter

**檔案：**
- 新增：`fixtures/service-catalog.json`
- 新增：`fixtures/handoff-scenarios.json`
- 新增：`src/adapters/catalog.ts`
- 新增：`src/adapters/handoff.ts`

**步驟：**
1. 建立至少 12 筆合成服務卡，覆蓋一般查找、到府偏好、資料過期與無可用服務。
2. 每筆服務卡加入來源 URL、取得時間、`mock`、資料狀態與聯絡／地圖入口占位資訊。
3. 實作只讀 Catalog Adapter 和只模擬的 Handoff Adapter。
4. 準備受理、拒收、取消與失敗四種事件回傳。

**驗證：** 測試 Adapter 無網路依賴；檢查所有回傳資料具有真相來源欄位；禁止任何 HTTP POST 指向真實服務端。

### 工作包 2：實作 AI 行政欄位整理與安全檢查

**檔案：**
- 新增：`src/ai/parseAdministrativeRequest.ts`
- 新增：`src/ai/policyGuard.ts`
- 新增：`tests/ai/*.test.ts`

**步驟：**
1. 寫入 system prompt：只轉換地點、時間、交通／到府偏好、服務類型與聯絡偏好。
2. 以 schema 強制輸出；模型無法填入的值回傳 `unknown`。
3. 加入政策守門：任何診斷、治療、檢傷、處方、檢驗解讀或緊急程度要求，改回固定限制文案和正式緊急入口資訊。
4. 建立不使用真實健康案例的測試語句集。

**驗證：** 模型或 mock 回應必須通過 schema；10 條臨床意圖測試均不產生醫療判斷；未由 Adapter 回傳的服務名稱不得出現在回應。

### 工作包 3：建立消費者端互動流程

**檔案：**
- 新增：`src/app/page.tsx` 或對應前端入口
- 新增：`src/components/RequestEntry.tsx`
- 新增：`src/components/ConditionEditor.tsx`
- 新增：`src/components/ServiceCards.tsx`
- 新增：`src/components/HandoffConfirm.tsx`
- 新增：`src/components/HandoffStatus.tsx`

**步驟：**
1. 建立六個畫面：入口、條件確認、服務清單、服務比較、交接確認、交接狀態。
2. 每個服務卡顯示來源、資料時間、資料狀態和「模擬資料」標示。
3. 交接確認頁清楚寫出：此為內部 Prototype，平台只模擬調用外部服務端，不建立真實預約、不傳送真實資料。
4. 使用者確認前停留在草稿狀態；確認後只調用 mock Adapter。

**驗證：** Playwright 完成四組固定情境；快照中可見來源、時間、模擬標示與確認步驟。

### 工作包 4：建立管理端稽核與失敗回復

**檔案：**
- 新增：`src/admin/AuditLog.tsx`
- 新增：`src/admin/DataProvenance.tsx`
- 新增：`src/admin/StateRecovery.tsx`
- 新增：`src/audit/logger.ts`

**步驟：**
1. 記錄會話 ID、同意版本、工具名稱、輸入摘要、輸出摘要、時間與事件 ID。
2. 提供資料來源檢視，顯示每筆服務資料的來源與 fixture 狀態。
3. 提供狀態失敗頁，顯示原因並允許回到草稿。
4. 加入遮罩規則，避免把自由輸入原文或敏感字串寫入日誌。

**驗證：** 觸發模擬拒收與工具失敗，管理端可追蹤事件鏈；日誌掃描不含受限制資料欄位。

### 工作包 5：整合、紅隊測試與交付包

**檔案：**
- 新增：`tests/e2e/medical-prototype.spec.ts`
- 新增：`docs/product/medical-mvp/test-cases.md`
- 新增：`docs/product/medical-mvp/known-limitations.md`
- 新增：`docs/product/medical-mvp/demo-script.md`

**步驟：**
1. 跑四組主路徑與十組臨床意圖阻擋測試。
2. 檢查所有 UI、fixture、prompt、日誌與錯誤訊息均未宣稱真實預約、即時受理或醫療建議。
3. 建立 5 分鐘 demo script，依序展示輸入、條件可編輯、來源、確認、模擬狀態與管理端稽核。
4. 整理已驗證能力、未驗證事項、下一階段需求與停止條件。

**驗證：** CI 通過；人工依 demo script 重跑成功；輸出一份 Prototype 限制清單。

---

## 交付與審查門檻

| 交付物 | 驗收標準 | 不合格處置 |
|---|---|---|
| 可操作 Prototype | 六個畫面與四組情境可重現。 | 退回對應工作包修正。 |
| AI 輸出控制 | 僅含行政 schema；臨床意圖受阻擋。 | 停止模型串接，修正 prompt／guard／schema。 |
| 資料來源呈現 | 每筆服務卡具來源、時間、狀態及 mock 標示。 | 停止展示該資料。 |
| 狀態可回溯 | 每次模擬交接可追蹤事件與失敗原因。 | 停止展示成功狀態。 |
| 安全聲明 | 無真實醫療資料、預約、支付或 SLA 宣稱。 | 停止對外展示。 |

## 後續 Gate

完成本計畫只代表 Prototype 技術與流程可展示。進入真實市場或合作端試點前，需另立研究命題，取得受訪者訪談、合作端資料契約與書面法務意見；該階段需重新做 grill-me 審查。
