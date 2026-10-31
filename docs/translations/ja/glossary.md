# Japanese glossary (ja): DRAFT, awaiting native review

**Status: draft, awaiting native review.** Written by the translation agent on 2026-10-31 from the English UI and the
German glossary's term list, before any Japanese string is drafted. It is for a Japanese-speaking ham reviewer to agree
or correct. Review does not gate the release (owner, 2026-10-30): if answers come later, the draft is changed to match.
Every later Japanese string follows this table, so one English word is never rendered three ways.

- **How to review:** for each row, keep it or write the better term in the last column. Rows marked **❓** are real
  choices where Japanese ham usage is split, or where the agent is unsure; the reviewer decides.
- **Register:** です/ます in sentences, plain noun or verb forms on buttons and labels (see `style.md` §1).
- **Script:** half-width ASCII for numbers, units, mode names and abbreviations (FM, DMR, APRS, TG, PTT); full-width
  Japanese punctuation 、。「」（）. One half-width space between Japanese and Latin letters or digits ("APRS ワッチ",
  "5 W", "30 秒"), as Android's Japanese UI does (`style.md` §3).
- **Long vowels:** modern rule, final ー written (レピーター, メーター, タイマー, スキャナー), as Android and current
  radio-maker manuals write. ❓ JARL documents often drop it ("レピータ局"); see `style.md` §3.2.
- **Order:** app navigation, buttons, radio terms, DMR, digital modes, safety and licence, units and symbols, then the
  terms the German draft needed (§8).

## 1. App structure: tabs, pages, features

| English | Japanese | Why / notes | Reviewer |
|---|---|---|---|
| SignalDeck | SignalDeck | Product name, never translated or written in katakana. | |
| SignalDeck Web | SignalDeck Web | Product name. | |
| Intercom (tab, main page) | 無線 | ❓ インターコム in Japanese is a door or office intercom; the page is the radio's front panel. 無線 is two characters and reads as "the radio". Alternatives: インターコム (keeps the English name, as German did), 交信. Prose: 「無線画面」. | |
| Channels (tab) | チャンネル | Android and radio manuals write チャンネル (not チャネル). | |
| Contacts (tab) | 連絡先 | ❓ Android's word. Japanese DMR radio menus often say コンタクト; the tab holds DMR contacts too. | |
| Messages (tab) | メッセージ | Android standard. | |
| Device (tab) | デバイス | Android's Japanese UI. | |
| Settings | 設定 | Android standard. | |
| Radio settings | 無線設定 | | |
| Last heard | 最近の受信 | ❓ No Japanese DMR dashboard term is established; ラストハード is jargon. Short label: 受信履歴. | |
| Activity | アクティビティ | Android's word. | |
| Activity statistics | アクティビティ統計 | | |
| Alerts (list in Last heard) | 警告 | The list holds warnings and refusals; お知らせ is too weak. | |
| Car and coverage | 車とエリア | Follows "coverage" → エリア (❓ below). | |
| Guide / Help | ガイド / ヘルプ | ヘルプ for the menu entry, ガイド for the guide itself. | |
| Getting started | はじめに | Standard heading in Japanese manuals. | |
| Good to know | 知っておくと便利 | | |
| Take over (the radio) | 引き継ぐ | ❓ "無線モジュールを引き継ぐ" in prose. Alternative: 制御を取得. Pairs with 戻す. | |
| Hand back | 戻す | "純正アプリに戻す". | |
| Stock app (the phone maker's radio app) | 純正アプリ | 純正 is the exact Japanese word for "stock / maker-supplied". "純正のトランシーバーアプリ" where the English says "stock walkie-talkie app". | |
| Device report | デバイスレポート | The report itself stays English (`research.md` §3). | |
| Transmit test | 送信テスト | | |
| First-run check | 初回チェック | Run all checks: 「すべてチェック」. | |
| Module firmware | モジュールのファームウェア | Label short form: モジュール FW is too terse; keep the full form. | |
| Radio module | 無線モジュール | | |
| About this radio | この無線機について | Android pattern 「〜について」. | |
| Live captions (TXT) | ライブ字幕 | ❓ Google's Live Caption is 自動字幕起こし in Japanese; ライブ字幕 is shorter and clear. Key legend TXT stays. | |
| Keywords (caption alerts) | キーワード | | |
| Recording(s) | 録音 | No plural in Japanese. | |
| Recordings player | 録音プレーヤー | | |
| Transcript | 文字起こし | | |
| Coverage logging | エリア記録 | ❓ Japanese carriers say エリア / エリアマップ for coverage; カバレッジ is also understood (more technical). 「車でエリアを記録」. Plain "range" (how far a signal reaches) is 到達距離 / 飛距離. | |
| Coverage map | エリアマップ | Carrier usage; follows the row above. | |
| Map | マップ | Labels マップ, prose 地図 where it reads better. | |
| Band scope | バンドスコープ | The word Icom and Yaesu Japanese manuals use. | |
| Fox hunt | フォックスハンティング | Japanese hams write FOXハンティング or フォックスハンティング; ARDF is アマチュア無線方向探知 (JARL). | |
| Nets | ロールコール | The Japanese ham word for an on-air net. | |
| Net control | キー局 | The established Japanese term for the station running a roll call. | |
| Logbook | ログ | ❓ ログ / 交信ログ; 業務日誌 is the old legal logbook term and too formal. | |
| Exam practice | 試験対策 | The pools are the US exam in English: label the topic 「米国の試験（英語）」. | |
| Conditions (propagation) | コンディション | Japanese ham usage ("コンディションがいい"). 「VHF/UHF のコンディション」. | |
| Satellites | 衛星 | | |
| Pass (satellite) | パス | Japanese satellite hams say パス. | |
| Emergency | 緊急 | Emergency traffic is 非常通信 in Japanese ham usage; the app feature is 緊急. | |
| Restricted mode | 制限モード | A voluntary PIN lock. | |
| Widget | ウィジェット | Android standard. | |
| Android Auto | Android Auto | Product name. | |
| Zone | ゾーン | Japanese DMR radio menus. | |
| All channels | 全チャンネル | Short; すべてのチャンネル in prose. | |
| Favourites | お気に入り | Android standard. | |
| Priority channel | 優先チャンネル | Radio manuals also write プライオリティチャンネル; 優先 is shorter. | |
| Make scan priority | 優先にする | Button: short. | |
| Busiest channels (zone name) | 活発なチャンネル | A zone name the app creates. | |
| Restricted PIN | 制限 PIN | | |

## 2. Buttons and common actions

Buttons are plain noun forms (Sino-Japanese nouns: 保存, 削除) or short dictionary-form verbs (閉じる, 戻る), as
Android's Japanese UI writes them. Never です/ます, never 〜してください on a button.

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| OK | OK | Android Japanese keeps OK. | |
| Cancel | キャンセル | | |
| Save | 保存 | | |
| Delete | 削除 | | |
| Close | 閉じる | | |
| Done | 完了 | | |
| Back | 戻る | | |
| Next / Previous (guide pages) | 次へ / 前へ | | |
| Continue | 続行 | | |
| Later | 後で | | |
| Not now | 今はしない | | |
| Clear | クリア | For lists; 「リセット」 for fields. | |
| Start / Stop | 開始 / 停止 | | |
| End (a net, a session) | 終了 | | |
| Send | 送信 | Also "transmit" (§3). The context tells them apart; never 発信 (that is a phone call). | |
| Share | 共有 | Android standard. | |
| Import / Export | インポート / エクスポート | | |
| Download | ダウンロード | | |
| Load (firmware) | 書き込む | 「ファームウェアを書き込む」, the radio-maker word; not フラッシュ in UI text. | |
| Connect | 接続 | | |
| Defaults | 初期値 | Also 「初期値に戻す」. | |
| Use (a channel) | 使用 | 「このチャンネルを使用」. | |
| Use it anyway | このまま使用 | | |
| Tune (a frequency) | 合わせる | 「周波数を合わせる」; button form 「設定」 where only one word fits. | |
| Edit | 編集 | | |
| Add | 追加 | | |
| Rename | 名前を変更 | Android standard. | |
| Search | 検索 | | |
| Retry | 再試行 | | |
| Allow | 許可 | Matches Android permission dialogs. | |
| Turn on / Turn off | オンにする / オフにする | Switch rows: just the label. | |
| On / Off | オン / オフ | | |
| Tap | タップ | 「SCAN をタップします」. | |
| Long-press | 長押し | 「SCAN を長押しします」. | |
| Swipe | スワイプ | | |
| Put in the outbox | 送信トレイへ | Winlink/messages. | |

## 3. Radio and ham terms

| English | Japanese | Why / notes | Reviewer |
|---|---|---|---|
| radio (the device) | 無線機 | トランシーバー for a handheld in casual prose. | |
| radio (the activity) | 無線 | | |
| ham, radio amateur | アマチュア無線家 | ハム is common and friendly; 無線家 in short text. Not gendered. | |
| amateur radio | アマチュア無線 | | |
| callsign | コールサイン | ❓ What hams say and write. 呼出符号 is the Radio Act (電波法) term: use it only in licence text if the reviewer wants. | |
| licence | 免許 | ❓ Japan has two: the operator's licence (無線従事者免許) and the station licence (無線局免許). The app text means "you must be licensed": 「アマチュア無線の免許」 covers both. | |
| channel | チャンネル | | |
| frequency | 周波数 | | |
| transmit (verb) | 送信する | | |
| transmission (one over) | 送信 | 「1 回の送信」 where one over is meant. | |
| receive | 受信する | | |
| reception | 受信 | | |
| receive-only | 受信専用 | | |
| talk key (the big round button) | 送信キー | ❓ 送話キー / トークキー are alternatives. | |
| PTT | PTT | Kept; 「PTT ボタン」 in prose. | |
| side PTT button | 側面の PTT ボタン | | |
| squelch | スケルチ | Universal in Japanese ham usage; SQL on tight labels. The feature name **Soft SQ** stays. | |
| squelch level | スケルチレベル | 「SQL レベル」 on tight labels. | |
| Soft SQ | Soft SQ | Feature name, kept. Explained once as 「ソフトウェアスケルチ」. | |
| noise squelch | ノイズスケルチ | Japanese manuals use this. | |
| scan (verb / noun) | スキャンする / スキャン | Key legend stays **SCAN**. | |
| zone | ゾーン | | |
| VFO | VFO | | |
| repeater | レピーター | ❓ JARL writes レピータ (レピータ局); 中継局 is the generic/legal word and reads stiff. Pick one spelling for the whole app. | |
| repeater offset / shift | オフセット | ❓ Japanese hams also say シフト ("マイナス 5 MHz シフト"). | |
| simplex / duplex | シンプレックス / デュプレックス | "シンプレックスで" is ham speech; 単信 is legal/technical. | |
| CTCSS | CTCSS | Japanese manuals call it トーンスケルチ (TSQL); keep CTCSS as the label, explain 「トーンスケルチ」 once. | |
| DCS | DCS | デジタルコードスケルチ once in prose. | |
| tone (CTCSS) | トーン | 「受信トーン」 / 「送信トーン」 for RX/TX tone. | |
| power (transmit) | 送信出力 | Short labels: 出力. | |
| high / low (power) | ハイ / ロー | The radio-panel words. | |
| bandwidth wide / narrow | ワイド / ナロー | With values: 25 kHz / 12.5 kHz. | |
| channel step | 周波数ステップ | Labels: ステップ. | |
| mode (FM, DMR …) | モード | 電波型式 (F3E…) is the legal term, not for UI. | |
| analog / digital | アナログ / デジタル | | |
| signal strength | 信号強度 | | |
| S-meter | S メーター | | |
| noise floor | ノイズフロア | | |
| NO SIGNAL | 信号なし | | |
| channel busy | チャンネル使用中 | | |
| key up (a repeater) | アクセスする | 「レピーターにアクセス」 is the Japanese ham phrase. ❓ キーアップ. | |
| repeater tail | テール | ❓ ハングタイム. | |
| roger beep | ロジャービープ | ❓ Also 送信終了音 / エンドトーン. | |
| QSO, CQ, 73, QTH | unchanged | International; QSO also 交信 in prose. | |
| location | 位置 | 「現在地」 for the phone's own position; QTH / 運用地 in ham-flavoured text. | |
| locator / grid square | グリッドロケーター | JARL usage; GL on tight labels. | |
| band | バンド | Also 〜帯 in prose: 「430 MHz 帯」. | |
| band plan | バンドプラン | | |
| VHF / UHF | VHF / UHF | Japanese hams say 144 MHz 帯 / 430 MHz 帯 (or 「2 m」/「430」): use those in prose where the band is meant. | |
| propagation | 伝搬 | 電波伝搬 in prose. | |
| antenna | アンテナ | | |
| dummy load | ダミーロード | | |
| interference | 混信 | Between stations; 干渉 / ノイズ for other interference. | |
| identification (repeater ID) | ID | 「ID 送出」 for sending the ID. | |
| Morse | モールス / CW | | |
| beacon | ビーコン | APRS too: 「APRS ビーコン」. Propagation beacons also ビーコン. | |
| heard station | 受信した局 | | |

## 4. DMR

| English | Japanese | Why / notes | Reviewer |
|---|---|---|---|
| DMR | DMR | | |
| talkgroup | トークグループ (TG) | One katakana word, no space or ・. TG on tight labels. | |
| colour code | カラーコード (CC) | | |
| time slot | タイムスロット (TS) | 「スロット 1」 in short text. | |
| private call / group call | 個別呼出 / グループ呼出 | The words Japanese digital radios (DCR, DMR) use. | |
| DMR ID | DMR ID | (Never a real ID in examples.) | |
| contact | 連絡先 | ❓ See §1; コンタクト on DMR radios. | |
| receive group list | 受信グループ | ❓ RX グループリスト. | |
| hotspot | ホットスポット | | |
| codeplug | コードプラグ | ❓ Japanese users often just say 設定データ / チャンネルデータ. | |
| CALL · PICKED | 呼出 · 選択 | Intercom cell legend. | |
| promiscuous mode (MON) | 全受信 (MON) | For prose; the key legend MON stays. | |

## 5. Digital modes and data

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| APRS, AX.25, iGate, digipeater | unchanged | デジピーター in prose is also fine. | |
| APRS-IS, passcode | APRS-IS, パスコード | | |
| packet radio | パケット通信 | | |
| position (APRS) | 位置 | | |
| telemetry | テレメトリー | | |
| weather report | 気象情報 | | |
| message (APRS/DMR text) | メッセージ | | |
| outbox / inbox | 送信トレイ / 受信トレイ | Android/Gmail Japanese. | |
| SSTV, FT8, M17, POCSAG, Winlink, DTMF | unchanged | | |
| picture (SSTV) | 画像 | | |
| pager | ページャー | ❓ Japanese everyday word is ポケベル (ポケットベル). | |
| decode / decoder | デコード / デコーダー | | |
| forms (Winlink) | フォーム | | |

## 6. Safety, licence, heat

Safety text gets a second careful pass (plan §4). These renderings must stay this strong.

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| Warning | 警告 | | |
| Caution | 注意 | | |
| Transmitting legally | 送信と法令 | Guide section title. ❓ 合法的な送信 reads like a translation. | |
| You need a licence to transmit on this frequency. | この周波数で送信するには、アマチュア無線の免許が必要です。 | The pattern for licence notes. | |
| transmit limit / time limit | 送信時間制限 | | |
| Longest transmission | 最長送信時間 | Device setting. | |
| heat guard | 過熱保護 | | |
| too hot | 高温 | 「高温のため送信できません」. | |
| transmit refused | 送信不可 | Headline form; sentence 「送信できません」. | |
| Not sent | 未送信 | | |
| advisory (from the profile list) | 注意情報 | | |
| firmware loader | ファームウェア書き込み | As a label; in prose 「ファームウェア書き込み」はスマートフォンでのみ使えます。 | |
| factory image | 純正ファームウェア | | |
| do not switch off | 電源を切らないでください | Firmware loading: always bold, never softened; 「絶対に」 where the English stresses it. | |
| emergency | 緊急 | | |

## 7. Units, numbers, symbols

| English | Japanese | Notes |
|---|---|---|
| 467.625 MHz | 467.625 MHz | **Decimal point**, as English: Japan uses the point. No change to `Txt.freq` for ja. |
| 12.5 kHz | 12.5 kHz | |
| −85 dBm | −85 dBm | Half-width, space before the unit, real minus sign. |
| 30 s, 2 min | 30 s, 2 min (labels) / 30 秒、2 分 (prose) | ❓ Compact readouts keep the symbols; sentences use 秒/分, with Android's space ("30 秒"). |
| 5 W | 5 W | |
| 24-hour time | 14:05 | Always 24-hour; never 午後 2:05. |
| date | 2026/10/31 / 10月31日 | Short: 10/31; with weekday 10月31日（土）. |
| → (menu path) | → | Kept: 「デバイス → 無線設定」. |
| "…" quotes | 「…」 | Nested 『…』. |
| , and . in sentences | 、。 | Full-width. A half-width comma only inside ASCII runs ("FM, DMR"). |
| ( ) | （ ） | Full-width in any string with Japanese in it. |
| : | ： | Full-width after Japanese; half-width in times (14:05) and ASCII runs. |
| … (ellipsis) | … | One character, as English: 「読み込み中…」. |
| 1–9 (range) | 1〜9 | Wave dash 〜 for ranges in Japanese text. |

## 8. Terms the German draft needed (2026-10-31)

Every term the German glossary's §8 settled, with the Japanese rendering. Rows marked **❓** are choices for the
reviewer.

### App features and screens

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| the Intercom page (in prose) | 無線画面 | Follows §1 (❓ there). | |
| Radio controls (car screen) | 無線操作 | 「車用の全画面無線操作」. | |
| Parrot (simplex repeater) | パロット | ❓ Or keep Parrot (BrandMeister's echo service, private call 9990, is "Parrot" everywhere). Prose 「パロット（シンプレックスレピーター）」 once. | |
| Voice keyer | ボイスメモリー | The Japanese radio-maker word (音声メモリー also seen). | |
| Net preamble / My ID (keyer slots) | ロールコール開始 / 自局 ID | 自局 is the Japanese ham word for "my station". | |
| ID timer | ID タイマー | | |
| ID reminder | ID 送出の通知 | | |
| Morse ID | CW ID | ❓ モールス ID. Also the DTMF command label. | |
| Fox beacon | フォックス送信機 | The hidden transmitter in a fox hunt. | |
| Be the fox | フォックスになる | | |
| bearing / Spin for the bearing | 方位 / 回して方位測定 | | |
| mark (fox hunt) | マーク | One word for prose and buttons: 「マークを保存」, 「マークを消去」. | |
| Download terrain / Terrain | 地形データをダウンロード / 地形 | | |
| Terrain prediction | 地形予測 | | |
| Key-ups (coverage layer) | アクセス | Follows §3 key up (❓ there). | |
| Mapping coverage | エリア記録中 | Notification and widget text. | |
| Log coverage in the car | 車でエリアを記録 | | |
| Nearby repeaters | 近くのレピーター | | |
| Nets near you | 近くのロールコール | | |
| On the air near you / Elsewhere on the air | 近くでオンエア中 / ほかの地域でオンエア中 | ❓ QRV 中 is ham shorthand; オンエア reads to everyone. | |
| Nets on this channel (editor section) | ロールコール | The section sits under the channel; one word is enough. | |
| Add a net | ロールコールを追加 | | |
| check-in (net control) | チェックイン | Used in Japanese roll calls (チェックイン局). Button 「チェックイン」. | |
| traffic (net flag) | 連絡あり | ❓ The station has traffic; トラフィック is emergency-comms jargon. | |
| Late / Out (net flags) | 遅れ / 退出 | | |
| Scheduled operations / schedule | 予約操作 / スケジュール | 「スケジュールを追加」. | |
| APRS monitoring | APRS ワッチ | ❓ ワッチ is the Japanese ham word for listening on a frequency. Never 監視 (surveillance). Alternative: APRS 受信. | |
| Pager monitor | ページャーワッチ | Follows the row above. | |
| Monitor APRS (button) | APRS をワッチ | | |
| Packet finder | パケット検索 | | |
| page (POCSAG message) | ページャーメッセージ | ❓ 呼出 / ポケベルメッセージ. | |
| Hear pages | ページャーを受信 | | |
| Winlink e-mail / Check Winlink mail | Winlink メール / Winlink メールを確認 | | |
| Session log / Detailed diagnostic log | セッションログ / 詳細診断ログ | | |
| Two-way iGate | 双方向 iGate | | |
| Packet lead-in | パケット前置き | ❓ TNC users know this as TXDELAY. | |
| Beacon via ISS | ISS 経由でビーコン | | |
| Record each pass | パスごとに録音 | | |
| satellite pass | 衛星パス | | |
| orbit data | 軌道データ | 「ISS の軌道データ」. ケプラー要素 only in technical prose. | |
| Text modes | テキストモード | | |
| Any mode (SSTV decoder) | すべて | An SSTV mode (Martin, Scottie): one word on the pill. | |
| Combine (SSTV) / In / Left out | 合成 / 使用 / 除外 | | |
| Voice announcements | 音声アナウンス | | |
| keyword alerts | キーワード通知 | | |
| Contribute | 協力する | | |
| Help support this phone | この端末の対応に協力する | "Help us support this phone" (first-launch title): 「この端末の対応にご協力ください」. | |
| Radio audio check | 無線音声チェック | | |
| Listen check / Second radio test | 受信音チェック / 2 台目の無線機でテスト | | |
| Transmit test session | 送信テストのセッション | | |
| Bring radio up (diagnostics) | 無線を起動 | Four buttons in a row. | |
| Probe + power pulse | 応答確認 + 電源パルス | | |
| Restore factory (firmware button) | 出荷時に戻す | One of three buttons in a row. | |
| POTA activation / On the air now | アクティベーション / 運用中 | | |
| contact (logbook) | 交信 | A DMR contact stays 連絡先 (§4); 「交信を記録」, 「もう一度記録」. | |
| Log heard | 受信局を記録 | | |
| Exam practice: Study a subelement / Missed | 分野を学習 / 間違えた問題 | Topic label per §1: 「米国の試験（英語）」. | |
| Hold to talk (M17) | 押して送信 | | |
| Open in maps | マップで開く | | |

### Firmware and the phone

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| phone | スマートフォン | 端末 on tight labels and in "this phone" (この端末). Never ケータイ. | |
| bench firmware / bench image | 試験用ファームウェア / 試験用イメージ | ❓ ベンチ is not used in Japanese for this; 開発用 is the alternative. | |
| stock firmware / factory image | 純正ファームウェア | As §6. | |
| stock version (SignalDeck Web) | 純正バージョン | | |
| factory backup / factory copy | 出荷時バックアップ / 出荷時コピー | | |
| stock ROM (Android) | 純正 ROM | Not firmware. | |
| symbol engine / tone generator | シンボルエンジン / トーン発生器 | | |
| Own the radio at boot | 起動時に無線モジュールを引き継ぐ | §1 Take over. | |
| Keep access after reboot | 再起動後もアクセスを維持 | | |
| Turn the radio off and exit | 無線モジュールをオフにして終了 | | |
| Hand back to the stock app and exit | 純正アプリに戻して終了 | | |
| Radio busy, loading firmware | 無線機は使用中です（ファームウェア書き込み中） | | |
| Allow unlisted images | 未登録のイメージを許可 | | |
| Web access / Allow transmit from the web | Web アクセス / Web からの送信を許可 | | |
| amber (UI colour) | オレンジ | 琥珀色 is literary. | |

### Channel editor and lists

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| All / Private / Group (call type choice) | すべて / 個別 / グループ | Short forms of §4, for pills. | |
| All call (contact type) | 一斉呼出 | ❓ オールコール on some DMR radios. | |
| Relay (repeater) | 中継（レピーター） | | |
| Call number from / call number | 呼出番号の取得元 / 呼出番号 | | |
| Channel access number (M17) | チャンネルアクセス番号 (CAN) | | |
| Double slot | ダブルスロット | | |
| Interrupt transmission | 送信割り込み | | |
| RX tone type / TX tone type | 受信トーン種別 / 送信トーン種別 | | |
| None (tone) | なし | | |
| High / Low power (choices) | ハイ / ロー | §3. | |
| Enabled / Disabled (choices) | 有効 / 無効 | | |
| Latitude / Longitude | 緯度 / 経度 | | |
| Destination (@ALL or a callsign) | 宛先（@ALL またはコールサイン） | | |
| NOT TUNABLE (badge) | 範囲外 | Three characters: fits where the German was cut. | |
| RX ONLY (badge) | 受信専用 | | |
| Not legal here | この地域では送信不可 | Short label: 送信不可. | |
| Show all lists | すべてのリストを表示 | | |
| Star (button) | お気に入り | | |
| Out of zone (button) | ゾーンから除外 | Four buttons share a row: short form 除外. | |
| Zone name | ゾーン名 | | |
| Marine VHF | 国際 VHF | The Japanese name for marine VHF. | |
| NOAA weather | NOAA 気象放送 | A US service; the name stays. | |
| Home (contact location) | 自宅 | "home location" → 「自宅の位置」. | |

### Wording rules settled

| English | Japanese | Notes | Reviewer |
|---|---|---|---|
| Stop … (button) | 〜を停止 / 〜停止 | §2 Start/Stop. 終了 only for End (a net, a session, the app). | |
| Halt TX | 送信停止 | | |
| Try again | 再試行 | §2 Retry. | |
| Loading… / Sending… | 読み込み中… / 送信中… | 〜中 noun form, no です. | |
| Set your callsign first | 先にコールサインを設定してください | | |
| Coverage logging is on | エリア記録はオンです | 「オン/オフ」 in sentences and on switches alike. | |
| No position fix yet | 位置を取得していません | Short label: 位置未取得. | |
| Key legends SCAN, ZONE, TXT, SOFT SQ, MON, REC, VFO, PKT | unchanged | No legend is translated. 「Soft SQ レベル」 keeps the name. The car screen's own Scan button is 「スキャン」. | |
| weekday buttons (one letter) | 日 月 火 水 木 金 土 | Japanese calendars start on Sunday, as Android ja does; ❓ the app may start on Monday (月 火 水 木 金 土 日). One kanji is also the short form; no three-letter form. | |
