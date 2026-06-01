import sqlite3

# Update channel 17 to use TG 64067 as TX contact
conn = sqlite3.connect('channel_db.db')
cursor = conn.cursor()

# Update txContact to 64067 (the talkgroup ID directly)
cursor.execute("UPDATE database_channel_area_default_uhf SET channel_txContact = 64067 WHERE channel_number = 17")
conn.commit()

# Verify the change
cursor.execute("SELECT channel_number, channel_name, channel_txContact, channel_contactType, channel_groups FROM database_channel_area_default_uhf WHERE channel_number = 17")
row = cursor.fetchone()
print("Updated Channel 17:")
print(f"  Number: {row[0]}")
print(f"  Name: {row[1]}")
print(f"  TX Contact: {row[2]}")
print(f"  Contact Type: {row[3]}")
print(f"  RX Groups: {row[4]}")

conn.close()
print("\n✓ Channel 17 updated - TX Contact now set to TG 64067")
