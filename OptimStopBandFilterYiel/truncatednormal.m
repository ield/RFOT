function aleat=truncatednormal(size,nsigmas)
%TRUNCATEDNORMAL generated random numbers with a truncated normal 
%                distribution. Truncation is made at nsigmas standard
%                deviations, which includes a 100*erf(nsigmas/sqrt(2)) 
%                percentage of the normal distribution.
%                When nsigmas=2  --> 95.5%
%                When nsigmas=3  --> 99.7%
%   aleat=TRUNCATEDNORMAL(size,nsigmas)
%
%   aleat = random number matrix.
%   size = size of matrix aleat
%   nsigmas = trucation criterium as number of standard deviations.

%   J. Esteban 2016
sizel=prod(size);
aleat=randn(sizel,1);
while ~isempty(find(abs(aleat)>nsigmas,1))
    inds=find(abs(aleat)>nsigmas);
    aleat(inds)=randn(length(inds),1);
end
aleat=aleat/nsigmas;
aleat=reshape(aleat,size);
