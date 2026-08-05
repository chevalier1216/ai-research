# 階段交接摘要

<!-- governance: handoff -->

> 僅交接下游必需的結論與 ID；原始來源、摘錄、搜尋過程與推理保留在上游檔案。

- 研究批次 ID／主題：2026-08-05／醫療產業鏈可行性／工具與整合條件
- 完成階段／交接版本：證據蒐集／v1
- 輸入產物 ID：研究計畫 01
- 交接結論（500 字內）：可形成「使用者語句→結構化服務需求→合作端即時服務確認→使用者確認→合作端履約→狀態通知與稽核」的技術閉環。LLM 用嚴格結構化工具呼叫輸出服務需求；MCP 封裝受控工具與 OAuth 授權；合作端 API 提供真實可約時段、服務範圍、派工、結果通知與取消狀態。Places/Maps URL/電話深連結可降低查找、導引與撥號門檻。任何醫療判讀、檢驗結果說明、服務資格、派工承諾與預約成立，必須由合作醫療或採檢端 API、流程與人員完成；不得由 LLM、MCP、地圖資料或公開電話資料替代。
- 已驗證主張 ID／證據 ID（最多 12 組）：T-01～T-09
- 主張狀態：T-01～T-09 已驗證；臺灣合作端 API 可用性、身分核驗方法、同意內容、醫療資料交換規格，待下一階段以合作方與法規來源驗證。
- 缺口登錄 ID（最多 3 項；無則填「無」）：G-TOOLS-01 臺灣醫療／到府採檢服務商 API 文件與 SLA；G-TOOLS-02 臺灣正式同意、身分與醫療資料最小欄位；G-TOOLS-03 合作端可接受之排程與通知事件格式。
- 限制與風險（最多 3 項）：地圖與電話資料不保證服務可用或可預約；FHIR 為互通標準，未證明任一臺灣服務商已實作；MCP/OIDC 僅處理受控存取，未授予合作端資料與履約權限。
- 下一位角色／唯一下一步／驗收條件：來源驗證角色／將 T-01～T-09 對照法規與合作端實況，補齊 G-TOOLS-01～03／逐一判定是否可放入臺灣最小可行服務鏈。
- 流程決定：前進。

## 工具與整合條件結論

| 功能層 | 工具／標準 | 輸入 | 輸出 | 需授權資料 | 失敗回復 | 無法替代的合作端 API／責任 |
|---|---|---|---|---|---|---|
| 需求轉譯 | LLM Responses API + 嚴格 JSON Schema 工具呼叫 | 使用者文字、已同意之偏好 | `service_request`：地點、時間窗、服務類別、聯絡偏好、確認狀態 | LLM 服務金鑰；禁止輸入非必要醫療內容 | 結構不完整即請使用者補填；不產生醫療結論 | 合作端服務資格、可派工與醫療內容判斷 |
| 受控執行 | MCP server + OAuth 2.1／PKCE | 已驗證工具參數、使用者授權範圍 | 工具呼叫結果、拒絕或錯誤狀態 | 每個工具最小 scope、短效 token、服務帳號或使用者授權 | 401 時重新授權；撤銷時停止後續工具；保留失敗事件 | 供應商 API token、資料存取政策、服務契約 |
| 地點／電話 | Google Places API | 地點、服務名稱、類型、語言、field mask | 場所 ID、名稱、地址、營業時間、電話、Maps URI | Google Cloud 專案、API key/OAuth、帳務 | 搜尋結果不一致或無資料時顯示查詢時間與人工搜尋／官方名錄連結 | 合作院所確認的地址、電話分機、當班狀態、可提供服務 |
| 導引／撥號 | Google Maps URLs；Android `ACTION_DIAL`／`tel:` | 場所 ID／目的地、電話號碼 | 使用者裝置開啟地圖或撥號畫面 | 裝置地圖／電話能力；撥號由使用者確認 | 無 Maps app 時瀏覽器開啟；無 dialer 時顯示可複製電話 | 院所接聽、分機路由、預約、服務承諾 |
| 身分／同意 | OIDC Authorization Code Flow；同意紀錄 | 登入請求、scope、同意版本 | ID token／access token、同意決定、時間戳 | 身分提供者、同意文字與版本、最小資料欄位 | 登入／同意失敗時不得讀取或送出受保護資料 | 受規範身分核驗、代理人／照護者授權、醫療資料同意 |
| 排程／狀態同步 | HL7 FHIR `Appointment`、`Subscription`；合作端 webhook／API | 時間窗、參與者、服務類別、訂單 ID、事件條件 | 預約／取消／完成狀態與事件通知 | 合作端 OAuth／mTLS 等憑證、事件端點、允許欄位 | 事件失敗重試、去重、狀態查詢；未確認不得顯示已成立 | 可用時段、派工、實際到府 ETA、採檢／就醫結果、取消與退款 |
| 通知 | 合作端 webhook，再由已同意之推播／SMS／email 通道送達 | 最小狀態、通知偏好 | 通知送達／失敗狀態 | 使用者通知同意、通道帳號與模板 | 通道失敗時改顯示 App 內狀態；不得以通知成功推定服務完成 | 服務商事件來源與客服處置 |
| 稽核 | 不可竄改事件帳本、集中安全日誌、關聯 ID | 授權、工具請求、結果摘要、同意版本、人工覆核、錯誤 | 可追查時間線、異常告警、刪除／保留策略 | 存取控制、金鑰、保留期限、遮罩規則 | 日誌管線失敗時阻擋高風險動作或改採人工流程 | 合作端履約紀錄、醫療紀錄、法定保存與調閱權限 |

## 已驗證資料來源與主張

| ID | 具體主張 | 來源／發布者／發布或存取日期／支持位置 | 限制 |
|---|---|---|---|
| T-01 | Places Text Search 以文字查詢與 field mask 回傳場所資料；相同查詢結果可能不同。 | [Text Search (New)](https://developers.google.com/maps/documentation/places/web-service/text-search)，Google for Developers，發布日頁面未列／存取 2026-08-05，§Text Search requests/responses、FieldMask（第 76–130 行）。 | 場所資料不等於合作端可服務、可預約或即時人力。 |
| T-02 | Google Maps URL 可跨平台開啟搜尋與路線；`api=1` 必填；不需 API key。 | [Maps URLs Get Started](https://developers.google.com/maps/documentation/urls/get-started)，Google for Developers，發布日頁面未列／存取 2026-08-05，§Introduction、Universal syntax、Launching actions（第 63–90 行）。 | 僅將使用者導至地圖，未執行預約或派工。 |
| T-03 | Android `ACTION_DIAL` 只開啟含號碼的撥號畫面，使用者自行按下通話；`ACTION_CALL` 需 `CALL_PHONE` 權限。 | [Common intents—Phone](https://developer.android.com/guide/components/intents-common.html)，Android Developers，發布日頁面未列／存取 2026-08-05，§Initiate a phone call（第 1505–1546 行）。 | iOS 與桌面需各自驗證；電話接通不代表服務成立。 |
| T-04 | OIDC 授權碼流程包含使用者驗證、同意、授權碼與 token 交換；資訊釋出前需同意決定。 | [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)，OpenID Foundation，2023-12-15／存取 2026-08-05，§3.1.2、§3.1.2.4（第 458–473、600–602 行）。 | 身分與同意流程不取代臺灣醫療資料同意要求。 |
| T-05 | HTTP MCP 可用 OAuth 2.1；人類使用者採 Authorization Code，服務對服務可採 Client Credentials；未授權時伺服器回 401。 | [MCP Authorization](https://modelcontextprotocol.io/specification/2025-03-26/basic/authorization)，Model Context Protocol，2025-03-26／存取 2026-08-05，§Purpose、Protocol Requirements、Grant Types、Authorization code grant（第 91–147 行）。 | MCP 不提供合作端資料、服務資格或履約能力。 |
| T-06 | FHIR `Appointment` 有服務類別、服務類型、時段、參與者與參與狀態欄位，可作為合作端排程交換候選模型。 | [FHIR R4 Appointment](https://hl7.org/fhir/R4/appointment.html)，HL7 International，FHIR R4.0.1／存取 2026-08-05，Structure（第 110–142 行）。 | 標準欄位未證明臺灣合作端採用或可直接寫入。 |
| T-07 | FHIR `Subscription` 可經 rest-hook、websocket、email、sms 或 message 傳遞事件；敏感資料通道需獨立安全控管。 | [FHIR R4 Subscription](https://hl7.org/fhir/R4/subscription.html)，HL7 International，FHIR R4.0.1／存取 2026-08-05，Structure/Safety and Security（第 81–104、267–275 行）。 | 訂閱在 access token 過期後可維持 active；需額外撤銷與權限治理。 |
| T-08 | NIST 指引涵蓋日誌基礎設施、健全日誌流程、稽核與問責。 | [NIST SP 800-92](https://csrc.nist.gov/pubs/sp/800/92/final)，NIST，2006-09／存取 2026-08-05，Abstract/Control Families（第 64–98 行）。 | 非臺灣法規；不能單獨決定醫療資料保存期限。 |
| T-09 | Responses API 可附加自訂函式、內建工具或遠端 MCP 工具；工具定義使用 schema。 | [OpenAI API Reference—Responses streaming](https://platform.openai.com/docs/api-reference/responses-streaming/response/refusal/delta?lang=curl)，OpenAI，發布日頁面未列／存取 2026-08-05，§tools／Function（頁內 API reference）。 | LLM 輸出仍需應用程式 schema 驗證、政策檢查與使用者確認；不可產生臨床判讀。 |
