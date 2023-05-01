% determine Is by Wang's simple equation
function Is = find_thermalInertia(G, Ts, lowerbound, upperbound, resolution)

% G is ground heat flux history
% Ts is the soil surface temperature history
% lowerbound is the lowest reasonable Is value
% upperbound is the largest reasonable Is value
% resolution is the measurement data resolution, e.g. half an hour means 2

w0 = 2*pi/86400;

Is = [];
for i = 1 : 24 * resolution : length(G) - 24 * resolution
    sub_Is = (max(G(i:i+24 * resolution)) - min(G(i:i+24 * resolution)))/(max(Ts(i:i+24 * resolution)) - min(Ts(i:i+24 * resolution)));
    sub_Is = sub_Is/sqrt(w0);
    Is = [Is, sub_Is];
end
Is(find(Is> upperbound |Is<lowerbound))=nan;
Is = mean(Is,'omitnan');