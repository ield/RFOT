function error=mappingerror_bpf(xxx,f,s11f,s21f,draw)
%MAPPINGERROR computes the error vector of the mapping between fine and
%             coarse functions for a waveguide band pass filter
%   error=MAPPINGERROR(xxx,f,s11f,s12f,s21f,s22f,B1,B2,draw)
%
%   xxx = parameter vector
%   f = frequency vector (Hz)
%   s11f = complex vector, s11 parameter obtained by the fine function
%   s21f =                 s21 
%   s12 and s22 are not included bacuse of symmetry
%   draw = draws a figure if true
%
%   error = real error vector to be minimized

%   J. Esteban 2016

% Transform the f from the Hz to GHz
f = f/1e9;

% Evaluates S-parameters with the coarse function
[s11c,s21c] = waveguidebandpassfiltercoarsefunction(xxx,f);
    
%
% Errors (neglects s12, since s12=s21)
% Estos errores nos los dan como relativos, pero los podemos cambiar a 
% absolutos o a los que nos parezca.
errors11=(s11f-s11c)./s11f; 
errors21=(s21f-s21c)./s21f;
error=[errors11 errors21];
error=[real(error) imag(error)];

%
if draw
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    figure(300);
    set(gcf, 'Color',[1 1 1]);
    title('Mapping')
    subplot(2,1,1)
    plot(f,-20*log10(abs(s11f)),...
         f,-20*log10(abs(s21f)),...
         f,-20*log10(abs(s11c)),'--',...
         f,-20*log10(abs(s21c)),'--')
    ylim([0 50])
    xlabel('Frequency (GHz)')
    ylabel('(dB)')
    legend('RL fine',...
           'IL fine',...
           'RL coarse',...
           'IL coarse',...
           'Location','best')
    subplot(2,1,2)
    plot(f,(180/pi)*angle(s11f),...
         f,(180/pi)*angle(s21f),...
         f,(180/pi)*angle(s11c),'--',...
         f,(180/pi)*angle(s21c),'--')
    xlabel('Frequency (GHz)')
    ylabel('(º)')
    legend('<s_{11} fine',...
           '<s_{21} fine',...
           '<s_{11} coarse',...
           '<s_{21} coarse',...
           'Location','best')
    drawnow
end
