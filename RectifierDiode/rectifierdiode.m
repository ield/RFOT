function error=rectifierdiode(V,f,t,draw)
% RECTIFIERDIODE computes the current error vector for HB
%   error=RECTIFIERDIODE(V,f,t,draw)
%
%   V = Column vector of harmonic voltage amplitudes V1 and V2
%       split in real and imaginary parts.
%   t = Time column vector (ns)
%   f = Frequency column vector (GHz)
%   draw = logical (T/F). Draws some figures if TRUE.
%
%   error = Column current error vector

%   J. Esteban 7/10/2016

jomega=1j*2*pi*f;
n_freq=length(f);
f_MAX=f(end);
Delta_t=t(2);
Delta_f=f(2);

% Recovers amplitudes as complex numbers becasue the ports were devided
% into the real and imaginary components
V1=V(       1:  n_freq,1)+1j*V(2*n_freq+1:3*n_freq,1);
V2=V(n_freq+1:2*n_freq,1)+1j*V(3*n_freq+1:4*n_freq,1);
V=[V1;
   V2];
% In time domain: the values are trandformed to the time domain simply
% using the fft
v1=rifftuni(V1);
v2=rifftuni(V2);

%
%%%
%%%%% Linear problem
%%%
%
% Source
V3=zeros(size(f)); V3(2)=1; % volts
% Circuit elements
RS=50; % ohms
RL=50; % ohms
C=0.008; % nF
%
ZERO=zeros(n_freq);
IDEN=eye(n_freq);       % Identity matrix
%
Is=[-IDEN/RS;
     ZERO]*V3;
YN=[IDEN/RS ZERO;
      ZERO   diag(1/RL+jomega*C)];

%
%%%
%%%%% Nonlinear problem
%%%
%
Isat=2e-6; % amperes
alpha=38; % volts^{-1}
i1nl=Isat*(exp(alpha*(v1-v2))-1);   % Low case v because we are in time
i2nl=-i1nl;
% In the frequency domain
I1NL=fftuni(i1nl);
I2NL=-I1NL;
INL=[I1NL;
     I2NL];

%%% Current error
error=Is+YN*V+INL;
% Split in real and imaginary parts
error=[real(error);imag(error)];


%
%%%
%%%%% Figures
%%%
%
if draw
    I=Is+YN*V;
    % Split
    I1=I(1:n_freq,1);
    I2=I(n_freq+1:2*n_freq,1);
    
    % Harmonic amplitudes and phases
    figure(1001)
    plot(f,20*log10(abs(1000*I1)),'r-o',...
         f,20*log10(abs(1000*I2)),'b-o',...
         f,20*log10(abs(1000*I1NL)),'m-o')
    legend('|I_1|',...
           '|I_2|',...
           '|I_{1 NL }|')
    title('HB amplitudes');
    xlabel('Frequency (GHz)')
    ylabel('(dB/mA)')

    figure(1002)
    plot(f,angle(I1)*(180/pi),'r-o',...
         f,angle(-I2)*(180/pi),'b-o',...
         f,angle(-I1NL)*(180/pi),'m-o')
    legend('<I_1',...
           '<-I_2',...
           '<-I_{1 NL}')
    title('HB phases');
    xlabel('Frequency (GHz)')
    ylabel('(degrees)')
     
    % Interpolation to improve figure
    Npundib=4;
    V3dib=[V3; zeros((Npundib-1)*(size(V3,1)-1),1)];
    v3dib=rifftuni(V3dib);
    V2dib=[V2; zeros((Npundib-1)*(size(V2,1)-1),1)];
    v2dib=rifftuni(V2dib);
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
    v2dib=repmat(v2dib,Nperiod,1);
    v3dib=repmat(v3dib,Nperiod,1);

    %
    figure(1003)
    plot(tdib,v3dib,'r',...
         tdib,v2dib,'b')
    legend('|V_3|',...
           '|V_2|')
    title('HB Voltages');
    xlabel('Time (ns)')
    ylabel('(V)')
 
    figure(1004)
    plot(f,20*log10(abs(1000*(I1+I1NL))),'r',...
         f,20*log10(abs(1000*(I2+I2NL))),'b')
    legend('|I_1+I_{1 NL}|',...
           '|I_2+I_{2 NL}|')
    title('HB Errors');
    xlabel('Frequency (GHz)')
    ylabel('(dB/mA)')
end
