% Descomentar para abrir um arquivo de voz diretamente
%[x, fs] = audioread('voz4.wav');

% Gravação do áudio
fs = 8000; % Hz
nBits = 24; % Quantidade de bits por amostra
nChannels = 1; % Quantidade de canais (mono ou estéreo)
duration = 5; % Segundos

recorder = audiorecorder(fs, nBits, nChannels); % Objeto para gravação
disp('comecou gravação');
recordblocking(recorder, duration); % Efetuando gravação
disp('terminou gravacao');

x = getaudiodata(recorder); % Valores do sinal gravado

% Coloca no dominio da frequencia
X = fft(x);
% Tamanho do vetor [Quantidade de Amostras]
NFFT = length(X);
% Fazendo a relacao das posições do vetor com a frequencia em Hz
F = fs * (-1/2:1/NFFT:(1/2)-1/NFFT);
%F = fs * ((-NFFT/2):(NFFT/2 - 1/NFFT))/NFFT;

subplot(4,2,1);
plot(F, abs(X)/NFFT);
title('Espectro da Frequência do Sinal Original')

X = fftshift(X);
subplot(4,2,3);
plot(F, abs(X)/NFFT);
title('FFTshift');

% componente DC
pontoCentral = NFFT/2; 
% deslocamento em hz
posicao = 255;
% calculo do deslocamento relativo á posição no vetor
% caso duvide do calculo, o valor pode ser encontrado a partir da proporcionalidade 
%
% posicao(hz)  ---- fs
% deslocamento ---- NFFT
deslocamento = (NFFT * posicao)/fs;
% calculo do deslocamento para a parte positiva
X_shiftedPositiva = [X(pontoCentral + deslocamento + 1: NFFT); zeros(deslocamento,1)];
% calculo do deslocamento para a parte negativa
X_shiftedNegativa = [zeros(deslocamento,1); X(1:pontoCentral - deslocamento)];
% junta a parte negativa e positiva
X_shifted = [X_shiftedNegativa(1:end); X_shiftedPositiva(1:end)];

% Retornando o sinal para o tempo
x_shifted = ifft(ifftshift(X_shifted));
subplot(4,2,5);
plot(F, abs(X_shifted)/NFFT);
title('Deslocamento Linear');
% Executa o audio modificado
sound(real(x_shifted), fs);

subplot(4,2,7);
Y = abs(ifftshift(X_shifted));
plot(F, Y/NFFT);
title('IFFTshift');


% Criando o eixo no tempo para plotar o sinal no tempo
dt = 1/fs;
t = 0:dt:(NFFT*dt)-dt;

subplot(4,2,2);
plot(t, x);
title('Sinal de voz tempo');

subplot(4,2,4);
plot(t, real(x_shifted));
title('Sinal de voz modificado');


