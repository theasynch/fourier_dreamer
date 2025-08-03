import numpy as np
import matplotlib.pyplot as plt

# Parameters
N = 300
t = np.linspace(0, 2*np.pi, N)

# Parametric shape - Lissajous curve
x = np.cos(3 * t) + np.cos(5 * t)
y = np.sin(4 * t) + np.sin(2 * t)
z = x + 1j * y

# FFT and frequencies
Z = np.fft.fft(z) / N
freqs = np.fft.fftfreq(N, d=(t[1]-t[0]))
Z_shifted = np.fft.fftshift(Z)
freqs_shifted = np.fft.fftshift(freqs)

# Sort by magnitude
indices = np.argsort(-np.abs(Z_shifted))
Z_sorted = Z_shifted[indices]
freqs_sorted = freqs_shifted[indices]

# Trace using top epicycles
num_terms = 50
frame = 100
point = 0
positions = []

for k in range(num_terms):
    freq = freqs_sorted[k]
    amp = np.abs(Z_sorted[k])
    phase = np.angle(Z_sorted[k])
    point += amp * np.exp(1j * (2 * np.pi * freq * t[frame] + phase))
    positions.append(point)

# Plot
fig, ax = plt.subplots(figsize=(6, 6))
ax.set_aspect('equal')
ax.axis('off')

# Draw epicycles
origin = 0
for pos in positions:
    ax.plot([origin.real, pos.real], [origin.imag, pos.imag], 'r')
    circle = plt.Circle((origin.real, origin.imag), abs(pos - origin), color='b', fill=False, linewidth=0.5)
    ax.add_artist(circle)
    origin = pos

# Draw the traced point
ax.plot([p.real for p in positions], [p.imag for p in positions], 'k-', linewidth=1)

plt.tight_layout()
plt.show()
