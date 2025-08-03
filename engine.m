% fourier_epicycles.m
pkg load signal  % Ensure signal package is loaded

% Sampling params
N = 300;  % Number of points
t = linspace(0, 2*pi, N);

% Define a cool parametric shape (Lissajous)
x = cos(3 * t) + cos(5 * t);
y = sin(4 * t) + sin(2 * t);
z = x + 1i * y;

% Compute Fourier Transform
Z = fft(z) / N;
freqs = fftshift((-floor(N/2):ceil(N/2)-1));  % Frequency components
Z = fftshift(Z);  % Shift zero frequency to center

% Sort by magnitude (for clean circle visualization)
[~, idx] = sort(abs(Z), 'descend');
Z_sorted = Z(idx);
freqs_sorted = freqs(idx);

% Prepare figure
figure;
axis equal;
axis([-3 3 -3 3]);
hold on;

% Initialize drawing
num_terms = 50;  % Number of epicycles
trace = zeros(1, N);

for frame = 1:N
    clf;
    axis equal off;
    hold on;

    point = 0;
    for k = 1:num_terms
        freq = freqs_sorted(k);
        amp = abs(Z_sorted(k));
        phase = angle(Z_sorted(k));

        prev_point = point;
        point = point + amp * exp(1i * (2 * pi * freq * t(frame) + phase));

        % Draw epicycle
        plot([real(prev_point), real(point)], [imag(prev_point), imag(point)], 'r');
        plot(real(point), imag(point), 'bo');
    end

    trace(frame) = point;
    % Draw the trace
    plot(real(trace(1:frame)), imag(trace(1:frame)), 'k', 'LineWidth', 2);
    drawnow;
end
