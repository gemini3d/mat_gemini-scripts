% Compute thermal conductivities transport coefficients in double precision
% so they can be hard code.  We've had some issue in the past in the single
% precision compiles where the ion thermal conductivity goes to zero
% because the numbers being multiplied/divided are too small; nevertheless
% the results *can* be represented in single precision so here we just
% compute them in double so that can be coded as literals with variable
% precision in fortran...

% declare all constant as 8 bit real (MATLAB's default)
amu=1.660539040e-27;    % should match fortran code in phys_consts module
ms=[16.0, 30.0, 28.0, 32.0, 14.0, 1.0, 5.485799090e-4]*amu;   % also must match
kB=1.38064852e-23
lsp=numel(ms);
coeffs=zeros(1,lsp-1);
Css=[0.22,0.16,0.17,0.16,0.24,0.90];

for isp=1:lsp-1    %leave off electrons; they seem to work fine calculated via single
    coeffs(isp)=25/8*kB^2/ms(isp)/(Css(isp)*1e-6);
end %for

disp(coeffs);