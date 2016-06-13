%% Model demodulatora 

% Cilj skripte je odrediti koja pjesma se prenosi OFDM-om...

clear all;
close all;

load ofdm_source03.mat


cyclic_prefix = 240;
ofdm_length = size(ofdm_source03, 2);
ofdm_sym_length = ofdm_length - cyclic_prefix;

broj_simbola = 48000; % 60 / 5 = 12 sekundi

offset = 1; % koji dio signala uzimamo

ofdm_sig = ofdm_source03(offset:offset+broj_simbola-1, :);
ofdm_cut = ofdm_sig(:, cyclic_prefix + 1:end);

komp = 1e4; % kompenziranje nosilaca na jedinicnu amplitudu

%% Demodulacija OFDM signala (FFT) 

OFDM = zeros(broj_simbola, ofdm_sym_length);
%w = ones(1, ofdm_sym_length);

% %for i=1:length(ofdm_cut(1,:))
% %    if mod(i, 2) == 0
% %        ofdm_cut(:,i) = ofdm_cut(:, i) * (-1);
% %    end
% %end

for s = 1:broj_simbola  
    OFDM(s,:) = fftshift(fft(ofdm_cut(s,:)));
end

%% Bacamo sve qpsk simbole u jednu dimenziju

qpsk_symbols = reshape(OFDM.', 1, ofdm_sym_length * broj_simbola) * komp;
qpsk_symbols = qpsk_symbols(2:2:end);

%% Konstelacija

%figure('name', 'Konstelacija');
%scatter(real(qpsk_symbols),imag(qpsk_symbols));

%% Demodulacija i dekodiranje

k = 1;
n = 1;
decoded_qpsk = double(zeros(1,length(qpsk_symbols)));
decoded_sample = int16(zeros(1, length(qpsk_symbols)));

while (k <= length(qpsk_symbols))   
    % Sastavljanje 16-bitne riječi 
    tmp_reg = int16(0);
    for i = 1:8
        tmp_reg = bitshift(tmp_reg, 2);
        tmp_reg = bitor(tmp_reg, bits_from_qpsk(qpsk_symbols(k + i - 1)));
    end
    decoded_qpsk(n) = double(tmp_reg)/2^15; %normiranje na -1 do 1
    decoded_sample(n) = tmp_reg;
    k = k + 8;
    n = n + 1;
end

%% Sviranje 

R = 1;
%t = 0:1/fs:1;
%h = sinc(t*fs/2);
%plot(t, h);
%sound(interp(decoded_qpsk, 2), fs);
sound(decoded_qpsk, fs);

%% Crtanje 
%plot(decoded_qpsk);

%player = audioplayer(interp(decoded_qpsk, R), fs , 16);
%play(player);







