
% ----------------------  Coleta de Dados .csv  -----------------------------
% 
% 
arquivo = 'Inverter_A_1.csv';

% Lê o arquivo CSV como texto

fid = fopen(arquivo, 'r');
readData = textscan(fid,'%s %s %s', 'Delimiter',',');
fclose(fid);

% Isola os dados a partir da linha 22
I = readData{2}(22:end);
V = readData{3}(22:end);

% Converte os dados para o formato numérico (double)
I = cellfun(@str2double, I);

% Caso a coleta tenha sido feito com a probe de corrente invertida
%I = -I; 

% Converte os dados para o formato numérico (double)
V = cellfun(@str2double, V);

%Limpa os auxiliares dados criados
clearvars -except V I 

%Cria o vetor tempo 
t = linspace(0, 4, 99999)';


% ------------------------- Gráfico da Corrente -----------------------------


% Plotando o gráfico
figure; % Cria uma nova janela de figura
plot(t, I, 'LineWidth', 1.5); % Definindo a espessura da linha

% Adicionando títulos e rótulos
title('Corrente Elétrica em Função do Tempo');
xlabel('Tempo (s)');
ylabel('Corrente (A)');

% Ajustando a aparência dos eixos
grid on; % Adiciona uma grade

% Definindo os deltas para cima e para baixo
deltaY_up = 0.15 * (max(I) - min(I));  % 25% da amplitude dos dados para cima
deltaY_down = 0.1 * (max(I) - min(I)); % 10% da amplitude dos dados para baixo

% Ajustando os limites do eixo Y
ylim([min(I) - deltaY_down, max(I) + deltaY_up]);

% Definindo os deltas para a esquerda e direita no eixo X
deltaX_left = 0.1 * (max(t) - min(t));  % 5% do intervalo de tempo para a esquerda
deltaX_right = 0.1 * (max(t) - min(t)); % 25% do intervalo de tempo para a direita

% Ajustando os limites dos eixos
xlim([min(t) - deltaX_left, max(t) + deltaX_right]);

% Definindo os yticks
yticks(min(I):0.5:max(I)); % Aqui estamos definindo ticks a cada 0.3 unidades de corrente.

ytickformat('%.2f'); % Mostra a corrente elétrica com 2 casas decimais

% Definição do tempo do arco sendo tempo1 o trigger do osciloscopio em 10v
% e tempo2 o momento de separação dos eletrodos
tempo1 = 0.802;
tempo2 = tempo1 + 2.7;


%Encontra o ultimo ponto que a corrente foi maior que 0.250mA
index_I_250 = find(I >= 0.250, 1, 'last');

% Define o tempo final do arco elétrico              
if index_I_250 < 99999
tempo2 = t(index_I_250);
end

% Adicionando as linhas verticais e textos        
hold on;
line([tempo1 tempo1], ylim, 'Color', 'r', 'LineStyle', '--'); 
text(tempo1 - 1.1, max(I) + deltaY_up/3, 'Antes do Arco', 'Color', 'k');

if index_I_250 < 99999
    line([tempo2 tempo2], ylim, 'Color', 'r', 'LineStyle', '--');
    text(tempo2 + 0.05, max(I) + deltaY_up/3, 'Depois do Arco', 'Color', 'k');
    
else
    line([tempo2 tempo2], ylim, 'Color', 'r', 'LineStyle', '--');
    text(tempo1 + 0.8, max(I) + deltaY_up/3, 'Durante o Arco', 'Color', 'k');
    
    line([tempo2 tempo2], ylim, 'Color', 'r', 'LineStyle', '--');
    text(tempo1 + 2.8, max(I) + deltaY_up/3, 'Eletrodos', 'Color', 'k');
    text(tempo1 + 2.75, max(I) + deltaY_up/15, ' Separando', 'Color', 'k');
    
end
hold off;

% ------------------------- Cálculo da Potência -----------------------------

Pot = I .* V;


index_tempo1 = find(t >= tempo1, 1, 'first');
index_tempo2 = find(t <= tempo2, 1, 'last');


delta_t = tempo2 - tempo1;

% segmento_pot contém os valores de potência entre tempo1 e tempo2.
segmento_pot = Pot(index_tempo1:index_tempo2);

n_Pot = length(segmento_pot);

J = sum(segmento_pot) * (delta_t / n_Pot);


% ------------------------- Gráfico da Tensão -----------------------------

figure; % Cria uma nova janela de figura
plot(t, V, 'LineWidth', 1.5); % Plotando a tensão em função do tempo

% Adicionando títulos e rótulos
title('Tensão Elétrica em Função do Tempo');
xlabel('Tempo (s)');
ylabel('Tensão (V)');

% Ajustando a aparência dos eixos
grid on; % Adiciona uma grade

% Definindo os deltas para cima e para baixo
deltaY_up = 0.1 * (max(V) - min(V));  % 25% da amplitude da tensão para cima
deltaY_down = 0.1 * (max(V) - min(V)); % 10% da amplitude da tensão para baixo

% Ajustando os limites do eixo Y
ylim([min(V) - deltaY_down, max(V) + deltaY_up]);

% Definindo os deltas para a esquerda e direita no eixo X
deltaX_left = 0.1 * (max(t) - min(t));  % 5% do intervalo de tempo para a esquerda
deltaX_right = 0.1 * (max(t) - min(t)); % 25% do intervalo de tempo para a direita

% Ajustando os limites dos eixos
xlim([min(t) - deltaX_left, max(t) + deltaX_right]);

% Definindo os yticks
yticks(min(V):5:max(V)); % Aqui estamos definindo ticks a cada 5 unidades de tensão.

ytickformat('%.2f'); % Mostra a tensão elétrica com 2 casas decimais

% Adicionando as linhas verticais e textos

hold on;
line([tempo1 tempo1], ylim, 'Color', 'r', 'LineStyle', '--'); 
text(tempo1 - 1.1, max(V) + deltaY_up/3, 'Antes do Arco', 'Color', 'k');

if index_I_250 < 99999
    line([tempo2 tempo2], ylim, 'Color', 'r', 'LineStyle', '--');
    text(tempo2 + 0.05, max(V) + deltaY_up/3, 'Depois do Arco', 'Color', 'k');
    
else
    line([tempo2 tempo2], ylim, 'Color', 'r', 'LineStyle', '--');
    text(tempo1 + 0.8, max(V) + deltaY_up/3, 'Durante o Arco', 'Color', 'k');
    
    line([tempo2 tempo2], ylim, 'Color', 'r', 'LineStyle', '--');
    text(tempo1 + 2.8, max(V) - (deltaY_up + 3), 'Eletrodos ', 'Color', 'k');
    text(tempo1 + 2.75, max(V) - (deltaY_up + 4), ' Separando', 'Color', 'k');
    
end
hold off;


% -------------------------  Plot dos Dados  -----------------------------

% % Criando uma tabela
% T = table(J, delta_t);
% 
% % Mostrando a tabela
% disp(T);

fprintf('\nA energia é: %f Joules\n\n', J);
fprintf('A duração do Arco é: %f segundos\n', delta_t);

