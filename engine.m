% Ensure signal package is loaded (no symbolic or extra stuff needed here)
pkg load signal;

% Number of points and parameter
N = 300;
t = linspace(0, 2*pi, N);

% Define the shape (Lissajous Curve Style)
x = cos(3*t) + cos(5*t);
y = sin(4*t) + sin(2*t);
z = x + 1i * y;

% Apply Fourier Transform
Z = fft(z) / N;
freqs = fftshift((-floor(N/2):ceil(N/2)-1));
Z = fftshift(Z);

% Sort by magnitude (for cleaner visuals)
[~, idx] = sort(abs(Z), 'descend');
Z_sorted = Z(idx);
freqs_sorted = freqs(idx);

% Animation Setup
num_terms = 50;       % Number of epicycles
trace = zeros(1, N);  % Stores traced shape

figure;
for frame = 1:N
    clf;
    axis equal off;
    hold on;

    point = 0;
    origin = 0;

    for k = 1:num_terms
        freq = freqs_sorted(k);
        coeff = Z_sorted(k);
        radius = abs(coeff);
        phase = angle(coeff);

        prev_point = origin;
        origin = origin + radius * exp(1i * (2 * pi * freq * t(frame) + phase));

        % Draw circle
        theta = linspace(0, 2*pi, 100);
        circ_x = real(prev_point) + radius * cos(theta);
        circ_y = imag(prev_point) + radius * sin(theta);
        plot(circ_x, circ_y, 'b', 'LineWidth', 0.5);

        % Draw rotating vector
        plot([real(prev_point), real(origin)], [imag(prev_point), imag(origin)], 'r');
    end

    trace(frame) = origin;
    plot(real(trace(1:frame)), imag(trace(1:frame)), 'k', 'LineWidth', 2);

    pause(0.01);  % Adjust for smoother playback
end

