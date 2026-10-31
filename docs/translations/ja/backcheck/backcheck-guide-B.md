# Back-check: ja guide part B (messages … transmitting-legally)

Scope: 10 topics, 102 sections (titles, summaries, heads and texts), about 50,000 Japanese characters.
Output: `ja-guide/partB.json`. Every section was translated back into English and compared with en.json in meaning.
The script check passed: ids match en.json, every `{@…}` matches, and no number is missing. The only extra numbers
are English number words written as digits ("two and a half" became 2.5, "ten" became 10, "one" became 1, and so on).
No decimal comma, no straight quotes, no あなた, and the Japanese/Latin spacing is clean.

## Meaning fixes

| Section | Problem found on back-translation | Fix |
|---|---|---|
| device / phone-profile | "It is your phone:" came out garbled and used あなた | 「それでも、決めるのはスマートフォンの持ち主です。」 |
| transmitting-legally / time-limit | 「無線機は自分では送信を止めません … 自分で止めるまで」: 自分 could be read as the radio itself, so it was unclear who ends the key (safety) | Rewritten: 「無線機が自動で送信を止めることはありません。送信を終えられるのは、キーを離す操作か SignalDeck … 手動で止めるまで（たとえばスマートフォンを再起動するまで）送信し続けます。」 |
| device / second-radio-test | "keep it quiet" was rendered as 無音にしておく, which reads as "mute it" | 「もう 1 台で送信しない」 |
| coverage-maps / driving-with-a-steady-signal | I had added a km/h conversion that is not in the English (a new number) | Removed: 「60 mph で走ると…」 |

## Name alignment with values-ja (checked just before finishing)
Changed so that plain-text names match the strings: カスタム PTT キー, 側面の PTT キー, 登録したキーを削除,
待機中のアニメーション, バックアップの往復を確認, 注意情報を再び適用, 今すぐ送信停止, カタログにないファームウェア,
ほかのアプリを選択…, 結果を送る, すべてのリストを表示, 距離の単位, 未確認 (to be confirmed), 正式版／ベータ版 (update
paths), ミッション (phone sheet) and ミッションステートメント (web card), 受信なし (QUIET meter), ハンドル (steering wheel,
everywhere), ハンドル送信のマイク, ダブル押し, 端末 / 車（通話として） (wheel mic choices), 制限なし (No limit),
タイムスロット：この端末の無線モジュールが決めます. Web names: 全体を表示 (Fit), 受信／送信到達 (coverage choice), 更新停止,
再生 (LISTEN), すべてのレピーター, 採点 (Morse trainer Check), チャンネルに戻る, CW ID を送信, 今すぐバックアップ, アップロード….

## Safety text read twice against the English
- transmitting-legally: licences (US rules kept as 「米国では」 for GMRS/FRS; receive-only channels) and time-limit (all
  limits, the 255 s radio timer, the No-limit risk, the heat-guard thresholds 30 s / 60 °C / 45 °C / 70 °C / 48 °C / 2 °C in 10 s / 1 °C / 17 min, locked in Restricted mode).
- signaldeck-web: transmitting (never transmits unless the switch is on; letting go, switching tabs or leaving the window always unkeys; 1.5 s; one talker) and safety (local network only, 5 wrong PINs, passcode never sent).
- device: radio-firmware (pre-flight checks, own risk / no warranty, certified phones only, attachments are public and belong to the maker, SignalDeck never uploads), transmit-test-session (opens only when the profile may transmit, never under an advisory or Restricted mode, 28 s limit, receive-only refuses), untested-profiles (transmit off until tested, exceptions only in the guided session), custom-ptt-key (transmit limit, receive-only, untested phones), run-all-checks (do not press PTT while the stock app is open; nothing tunes or transmits), device-report (share firmware files only privately and only if the maintainer asks), unihertz-atom-xl (Hand back warning about /sdcard/intercom/dmr), anysecu-w6plus-dmr (test cage, low power).
- emergency-and-roger-beep: hold-to-send, pick-the-right-channel (real emergencies only).
- coverage-maps: key-up-test (asks before transmitting; use sparingly), good-habits (no keying just to test; identify).
- region: safe-by-design (never transmits; responsibility stays with the licensee), how-accurate-it-is (licence-free means approved radios, not this phone).
- android-auto talk / widget talk (transmit limit, receive-only refuses).

## Unsure / for the reviewer
- 開発者向け設定 and 提供元不明のアプリ are Android Auto's own Japanese menu names as I remember them; check them against the
  Japanese Android Auto app (提供元不明のアプリ matches `device_set_auto_hidden_sub`).
- 「USB オーディオ ルーティングを無効化」（開発者向けオプション）: Android's Japanese name for this option, from memory.
- 「OK Google、SignalDeck で NOAA WX6 を再生して」: the example voice command in Japanese; it depends on the Assistant's language.
- The mission statement quote is a free translation.
