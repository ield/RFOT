function error=vanderpoloscillator(V,f,t,draw)
% VANDERPOLOSCILLATOR computes the current error vector for HB
%  error=VANDERPOLOSCILLATOR(V,f,t,draw)
%
%   V = Column vector of harmonic voltage amplitudes V1, split in 
%       real and imaginary parts.
%   t = Time column vector (ns)
%   f = Frequency column vector (GHz)
%   draw = logical (T/F). Draws some figures if TRUE.
%
%   error = Column current error vector

%   J. Esteban 7/10/2016

jomega=1j*2*pi*f;
n_frec=length(f);
f_MAX=f(end);
Delta_t=t(2);
Delta_f=f(2);

% Recovers amplitudes as complex numbers
V1=V(1:n_frec,1)+1j*V(n_frec+1:2*n_frec,1);
V=[V1];
% In time domain
v1=rifftuni(V1);

%
%%%
%%%%% Linear problem
%%%
%
% Circuit elements
L=0.5; % nH
RL=0.03;% Ohmios
C=0.009; % nF
GC=1/1000; % S
Yen=jomega*C+GC+1./(jomega*L+RL);
%
ZERO=zeros(n_frec);
IDEN=eye(n_frec);
%
YN=[diag(Yen)];


%
%%%
%%%%% Nonlinear problem
%%%
%
i1nl=(v1.^3)/3-v1;
% In the frequency domain
I1NL=fftuni(i1nl);
INL=[I1NL];

%%% Current error
error=YN*V+INL;
% Split in real and imaginary parts
error=[real(error);imag(error)];


%
%%%
%%%%% Figures
%%%
%
if draw
    I=YN*V;
    I1=I;
    
    % Harmonic amplitudes and phases
    figure(1001)
    plot(f,20*log10(abs(I1)),'r-o',...
         f,20*log10(abs(I1NL)),'m-o')
    legend('|I_1|',...
           '|I_{1 NL }|')
    title('HB amplitudes');
    xlabel('Frequency (GHz)')
    ylabel('(dB/mA)')

    figure(1002)
    plot(f,angle(I1)*(180/pi),'r-o',...
         f,angle(-I1NL)*(180/pi),'m-o')
    legend('<I_1',...
           '<-I_{1 NL}')
    title('HB phases');
    xlabel('Frequency (GHz)')
    ylabel('(degrees)')
 
    % Interpolation to improve figure
    Npundib=4;
    V1dib=[V1; zeros((Npundib-1)*(size(V1,1)-1),1)];
    v1dib=rifftuni(V1dib);
    I1dib=[I1; zeros((Npundib-1)*(size(I1,1)-1),1)];
    i1dib=rifftuni(I1dib);
    I1NLdib=[I1NL; zeros((Npundib-1)*(size(I1NL,1)-1),1)];
    i1nldib=rifftuni(I1NLdib);
    %
    tdib=linspace(0,max(t)+Delta_t*(Npundib-1)/Npundib,length(t)*Npundib)';
    %
    % Period repetitions to improve figure
    Nperiod=4;
    tmp=tdib;
    for ind=2:Nperiod
        tmp=[tmp; tdib+(ind-1)/Delta_f];
    end
    tdib=tmp;
    v1dib=repmat(v1dib,Nperiod,1);
    i1dib=repmat(i1dib,Nperiod,1);
    i1nldib=repmat(i1nldib,Nperiod,1);
    %
    figure(1003)
    plot(tdib,i1dib,'r',...
         tdib,-i1nldib,'m')
    legend('i_1',...
           'i_{1 NL}')
    ylim(max(abs(i1dib))*1.05*[-1 1]);
    title('HB Currents in time');
    ylabel('(A)')
    xlabel('Time (ns)')
     
    figure(1004)
    plot(tdib,v1dib,'m')
    legend('v_1')
    ylim(max(abs(v1dib))*1.05*[-1 1]);
    title('HB Voltage in time');
    ylabel('(V)')
    xlabel('Time (ns)')
     
    figure(1005)
    plot(f,20*log10(abs(V1)),'m-o')
    legend('|V_1|')
    title('HB Voltage in frequency');
    xlabel('Frequency (GHz)')
    ylabel('(dB/V)')
 
    figure(1006)
    plot(f,20*log10(abs(I1NL+I1)),'r')
    legend('|I_1+I_{1 NL}|')
    title('HB Errors');
    xlabel('Frequency (GHz)')
    ylabel('(dB/mA)')
end