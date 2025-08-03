pkg load signal;

% Parameters
N = 300;
t = linspace(0, 2*pi, N);

% Shape Definition
x = cos(3*t) + cos(5*t);
y = sin(4*t) + sin(2*t);
z = x + 1i*y;

% Fourier Transform
Z = fft(z) / N;
freqs = fftshift((-floor(N/2):ceil(N/2)-1));
Z = fftshift(Z);

% Sort by magnitude
[~, idx] = sort(abs(Z), 'descend');
Z_sorted = Z(idx);
freqs_sorted = freqs(idx);

% Settings
num_terms = 50;
trace = zeros(1, N);

% Create figure
fig = figure('Name', 'Fourier Drawing Engine', 'NumberTitle', 'off');

for frame = 1:N
    if ~isvalid(fig) || ~ishandle(fig)  % Break the loop if the window is closed
        disp('Figure closed. Animation stopped.');
        break;
    end

    clf(fig);  % Clear figure
    axis equal;
    axis([-3 3 -3 3]); % Adjust as needed
    axis off;
    hold on;

    origin = 0;
    for k = 1:num_terms
        freq = freqs_sorted(k);
        coeff = Z_sorted(k);
        radius = abs(coeff);
        phase = angle(coeff);

        % Draw circle
        theta = linspace(0, 2*pi, 100);
        circ_x = real(origin) + radius * cos(theta);
        circ_y = imag(origin) + radius * sin(theta);
        plot(circ_x, circ_y, 'b', 'LineWidth', 0.5);

        % Draw rotating vector
        new_point = origin + radius * exp(1i * (2*pi*freq*t(frame) + phase));
        plot([real(origin), real(new_point)], [imag(origin), imag(new_point)], 'r');
        origin = new_point;
    end

    trace(frame) = origin;
    plot(real(trace(1:frame)), imag(trace(1:frame)), 'k', 'LineWidth', 2);


    pause(0.01);
end

