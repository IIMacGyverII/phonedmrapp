# Back-check: Japanese guide, part A

Scope: `groups` (4) and topics `getting-started` … `contacts` (24 topics, 24 titles, 24 summaries, 155 sections,
about 48,700 Japanese characters). Output: `scratchpad/ja-guide/partA.json`.

I translated each section back into English without the source open, compared the meaning, and checked every number,
unit, negation and `{@…}` reference. Script checks: same ids and order as en.json; every `{@…}` present; no English
number missing (extra digits only where I wrote a spelled-out English number as digits, per style §7: "two and a half
seconds" → 2.5 秒, "twelve" → 12, "an hour or two" → 1〜2 時間); decimal points kept; no decimal commas, full-width digits,
ASCII quotes, あなた or ！; half-width space between Japanese and Latin/digits.

## Fixes made after the back-check

| Where | Problem in my first draft | Fix |
|---|---|---|
| packet-radio / decode-a-recording | Path read as "PKT → SSTV, or APRS → Decode"; English is PKT → (SSTV or APRS) → Decode | 「PKT → SSTV（または APRS）→ {@packet_pkt_decode_recording}」 |
| vfo / frequency-range | Back-translation said the *radio* refuses other frequencies; English: the app refuses them and never sends them | Subject made explicit: アプリが受け付けず…アプリがその周波数を無線機に送ることはありません |
| pager / sending | "If you are not already on a low-power wide channel there" came back garbled | 「すでにその周波数でローパワーかつワイドのチャンネルにいる場合を除き」 |
| packet-radio / aprs | "Monitor" rendered as a button 「APRS をワッチ」 that does not exist; the real button is 「%1$s をワッチ」 with the frequency | ワッチのボタン … 「144.390 MHz をワッチ」のように周波数が表示されます |
| packet-radio / morse | `{@intercom_chhistory_kind_morse} ID after I talk` would render 「送信後にモールス ID」, but the setting is 「送信後に CW ID」 | Setting named by its real label; the ref kept in the sentence: …ID を{@intercom_chhistory_kind_morse}で付けます |
| m17 / how-it-works | "shipped equalizer" first read as the factory one; it is the one that ships with the app | アプリ付属のイコライザー |
| m17 / how-it-works | "The Armor 26 Ultra has that measurement" was ambiguous (which measurement) | 「試験用ファームウェア用のその測定」 |
| fox-hunt / prediction | Fall-off rate "between open-ground and cluttered rates, chosen per hunt" came back as a fixed middle value | 信号の減衰率は開けた土地と障害物の多い土地の間で、ハントごとに選ばれます |
| logbook / stations-heard, soft-sq / the-slider | 中黒 between kanji/ASCII words (style §3.1) | rephrased without ・ |
| channels / zones-and-standard-lists | FRS "no licence", MURS "licence-free" could read as licence-free in Japan (style §10) | 「米国では免許不要」「米国で免許不要」 |
| 40 UI names in prose | Names differed from the `values-ja` strings written in parallel | Matched to values-ja (see list below) |

UI names aligned with values-ja: 予約を追加, FT8 停止, M17 停止, ID を送出した, 使用中 (ON AIR), ページャー (PAGER), 採点,
チャンネル保存, ビープ オン, フォックスの信号, フォックスを待機中, メッセージ送信, メール送信, 終了 / ロールコール開始 (net),
今後の予定, 今すぐ算出, 同じ周波数（ほかの地域かも）, 周波数をずらす, 自分のチャンネル (Your own), 自分のチャンネルを使う,
軌道データを更新, 事前に通知, 開始したら通知, 連絡先に保存, 回転, ゆっくり, その調子, 良 / 中 / 粗い, 最後の送信局,
送信後に CW ID, ゾーンを削除（チャンネルは残す）, ゾーンとその … チャンネルを削除, … をアクティベーション中,
この無線機の範囲外, … でロールコールらしき交信, 端末 / パケット端末, 掲示… / 掲示 (Bulletin), 無線で読み上げ, 交信を追加,
「無線」ページ (web), FM で FT8 (topic title, matches {@packet_pkt_ft8}).

## Safety text checked twice

- getting-started / talk-and-listen; m17 / talking-back: transmit limit 2 min, heat guard past 30 s.
- packet-radio / sstv: long-mode limits, cool-down (1 °C, ≤ 17 min), start blocked at 60 °C radio / 45 °C battery,
  transmission ended early past 70 °C / 48 °C / 2 °C in 10 s.
- packet-radio / morse: ID skipped within 3 s of the transmit limit.
- packet-radio / dtmf-remote-control: PIN lock (3 wrong in 10 min → 10 min), PIN never logged, off by default.
- channels / receive-only, intercom / channel: receive-only channels refuse Talk and every automatic transmission.
- channels / zones-and-standard-lists, vfo / band-plan: licence statements (GMRS US licence, Business licence,
  "not legal here", "whether you may transmit is your responsibility").
- winlink-e-mail / what-it-is: amateur licence needed.
- m17 / talking-back, pager / sending, pager / receiving: stock firmware cannot send / does not key / does not start.
- fox-hunt: marks refused while transmitting; never auto-mark while transmitting.
- packet-radio / iss: ISS SSTV receive only, transmitting blocked; scheduled-operations / when-it-runs.
- exam-practice / the-pools: added the style-guide sentence that the pools are the US exam (English), not Japan's.

No callsign, DMR ID or location was added (example callsigns N0ABC-1, CALL-7, W0C/FR-001, EM12ab are the English ones).
