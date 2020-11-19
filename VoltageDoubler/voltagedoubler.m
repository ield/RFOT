function error=voltagedoubler(V,f,t,draw)
% VOLTAGEDOUBLER computes the current error vector for HB
%   error=VOLTAGEDOUBLER(V,f,t,draw)
%
%   V = Column vector of harmonic voltage amplitudes V1, V2 and V3
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

% Recovers amplitudes as complex numbers
V1=V(         1:  n_freq,1)+1j*V(3*n_freq+1:4*n_freq,1);
V2=V(  n_freq+1:2*n_freq,1)+1j*V(4*n_freq+1:5*n_freq,1);
V3=V(2*n_freq+1:3*n_freq,1)+1j*V(5*n_freq+1:6*n_freq,1);
V=[V1;
   V2;
   V3];
% In time domain
v1=rifftuni(V1);
v2=rifftuni(V2);
v3=rifftuni(V3);

%
%%%
%%%%% Linear problem
%%%
%
% Source
V4=zeros(size(f)); V4(2)=10; % volts
% Circuit elements
RS=10; % ohmios
RL=50; % ohmios
C1=0.15; % nF
C2=0.11; % nF
%
ZERO=zeros(n_freq);
IDEN=eye(n_freq);
%
Is=[ ZERO;
   -IDEN/RS;
     ZERO]*V4;
YN=[diag(1/RL+jomega*C2)   ZERO         -IDEN/RL;
            ZERO            IDEN/RL        ZERO;
          -IDEN/RL           ZERO    diag(1/RL+jomega*C1)];

%
%%%
%%%%% Nonlinear problem
%%%
%
IS1=2.4e-6; % amperes
IS2=1.7e-6; % amperes
alpha1=32; % volts^{-1}
alpha2=45; % volts^{-1}
i1nl=IS2*(exp(alpha2*(v1-v2))-1);
i3nl=-IS1*(exp(alpha1*(v2-v3))-1);
i2nl=-(i1nl+i3nl);
% In the frequency domain
I1NL=fftuni(i1nl);
I3NL=fftuni(i3nl);
I2NL=-(I1NL+I3NL);
INL=[I1NL;
     I2NL;
     I3NL];

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
    I3=I(2*n_freq+1:3*n_freq,1);
    
    % Harmonic amplitudes and phases
    figure(1001)
    plot(f,20*log10(abs(1000*I1)),'r-o',...
         f,20*log10(abs(1000*I3)),'b-o',...
         f,20*log10(abs(1000*I1NL)),'m-o',...
         f,20*log10(abs(1000*I3NL)),'c-o')
    legend('|I_1|',...
           '|I_3|',...
           '|I_{1 NL }|',...
           '|I_{3 NL }|')
    title('HB amplitudes');
    xlabel('Frequency (GHz)')
    ylabel('(dB/mA)')

    figure(1002)
    plot(f,angle(I1)*(180/pi),'r-o',...
         f,angle(I3)*(180/pi),'b-o',...
         f,angle(-I1NL)*(180/pi),'m-o',...
         f,angle(-I3NL)*(180/pi),'c-o')
    legend('<I_1',...
           '<I_3',...
           '<-I_{1 NL}',...
           '<-I_{3 NL}')
    title('HB phases');
    xlabel('Frequency (GHz)')
    ylabel('(degrees)')
 
    % Interpolation to improve figure
    Npundib=4;
    V3mV1dib=[V3-V1; zeros((Npundib-1)*(size(V3,1)-1),1)];
    v3mv1dib=rifftuni(V3mV1dib);
    V4dib=[V4; zeros((Npundib-1)*(size(V2,1)-1),1)];
    v4dib=rifftuni(V4dib);
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
    v3mv1dib=repmat(v3mv1dib,Nperiod,1);
    v4dib=repmat(v4dib,Nperiod,1);

    %
    figure(1003)
    plot(tdib,v4dib,'r',...
         tdib,v3mv1dib,'b')
    legend('|V_4|',...
           '|V_3-V_1|',...
           'Location','South')
    title('HB Voltages');
    xlabel('Time (ns)')
    ylabel('(V)')
 
    figure(1004)
    plot(f,20*log10(abs(1000*(I1NL+I1))),'r',...
         f,20*log10(abs(1000*(I2NL+I2))),'g',...
         f,20*log10(abs(1000*(I3NL+I3))),'b')
    legend('|I_1+I_{1 NL}|',...
           '|I_2+I_{2 NL}|',...
           '|I_3+I_{3 NL}|')
    title('HB Errors');
    xlabel('Frequency (GHz)')
    ylabel('(dB/mA)')
    drawnow
end
