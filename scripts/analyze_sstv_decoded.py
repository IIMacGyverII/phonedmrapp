from PIL import Image
import numpy as np

img = Image.open(r'C:\Users\Joshua\AppData\Local\Temp\sstv_decoded.png')
arr = np.array(img)[:,:,:3]
h, w = arr.shape[:2]
print(f'Size: {w}x{h}')

col_var = arr.std(axis=0).mean()
row_var = arr.std(axis=1).mean()
print(f'Column variation (same x, across rows): {col_var:.2f}')
print(f'Row variation (same y, across cols): {row_var:.2f}')
print(f'Ratio col/row: {col_var/row_var:.2f}  (1.0=normal, <0.3=vertical stripes)')

print()
print('Per-column std (how much each column varies row-to-row):')
for x in range(0, w, 32):
    col = arr[:, x, :]
    std = col.std(axis=0)
    mean = col.mean(axis=0)
    print(f'  x={x:3d}: mean=({mean[0]:.0f},{mean[1]:.0f},{mean[2]:.0f}), std=({std[0]:.1f},{std[1]:.1f},{std[2]:.1f})')

print()
print('Per-row std (how much each row varies left-to-right):')
for y in range(0, h, 32):
    row = arr[y, :, :]
    std = row.std(axis=0)
    mean = row.mean(axis=0)
    print(f'  y={y:3d}: mean=({mean[0]:.0f},{mean[1]:.0f},{mean[2]:.0f}), std=({std[0]:.1f},{std[1]:.1f},{std[2]:.1f})')

# Save a larger version for easy viewing
img_big = img.resize((640, 512), Image.NEAREST)
img_big.save(r'C:\Users\Joshua\AppData\Local\Temp\sstv_decoded_2x.png')
print('\nSaved 2x upscaled version to sstv_decoded_2x.png')
