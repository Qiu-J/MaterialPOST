function  CCE()
global B C f1r t

ele=[0.65,0.909,0,0,0.111,0,0,1.504,1.080];%Ԫ�سɷ�
qunchT=100:2:230;%25:5:170;%����¶�
partT = 100:2:240;%qunchT;%240:2:500;%����¶�
% partt%���ʱ��
roomT=25;  %����

n = length(qunchT);  %����¶ȵĸ���
m = length(partT); %����¶ȵĸ���

C=ele(1);       %�õ�̼����
Mn=ele(2);      %�õ�Mn����
Ni=ele(3);      %�õ�Ni����
Mo=ele(4);      %�õ�Mo����
Cr=ele(5);      %�õ�Cr����
V=ele(6);       %�õ�V����
Al=ele(7);      %�õ�Al����
Si=ele(8);      %�õ�Si����
W=ele(9);       %�õ�W����
Fe=100-C-Mn-Ni-Mo-W-Si-Cr-Al-V;     %�õ�Fe����

B=(100-C)/(Fe/56+Si/28+Mn/55+Ni/58.7+Mo/95.9+Cr/52.0+V/51.0+Al/27.0+W/184.0);%��ȥC���ƽ����Է�������

Ms=539-423*C-30.4*Mn-12.1*Cr-7.5*Mo;  %MS��,��
% Ms = 550 - 350*C - 40*Mn - 35*V - 20*Cr - 17*Ni - Cu - 10*Mo - 5*W + 15*Co + 30*Al;
% Ms = 539 - 423*C - 30.4*Mn - 17.7*Ni - 12.1*Cr - 7.5*Mo;

% Bs = 830 - 270*C - 90*Mn - 37*Ni - 70*Cr - 83*Mo;
%�ƴ���-�ֵ��ȴ�������ƾ��鹫ʽ
disp(['����Ms�¶ȣ�' num2str(Ms)]);

phase1 = zeros(length(qunchT),3);

%����ѭ����
f1r=exp(-1.1*10^(-2).*(Ms-qunchT));%ע�⣬�������������mole����
phase1(:,1)=qunchT;%phase1���һ�δ�����ȡ���һ��Ϊ����¶�
phase1(:,2)=1-f1r;%phase1���һ�δ�����ȡ��ڶ���Ϊ��������
phase1(:,3)=f1r;%phase1���һ�δ�����ȡ�������Ϊ��������

%��ػ�����ȣ�����Ԫ�غ���
%���㹫ʽ
%% ������ѭ��������

%��ÿ������¶��£����¶Ȼػ�����ȣ������Ԫ�غ���
jieguo1 = zeros(n,m,4);
for i=1:n%ÿһ������¶�
    %������������
    f1r = phase1(i,3);%ע�⣬����Ӧ����mole����
    for j=1:m%ÿһ���ػ��¶�
        %����ػ��¶Ȳ���
        t = partT(j)+273.15;
        %�ⷽ�̼���ػ�����ȣ�����Ԫ�غ���
        options=optimset('MaxFunEvals',1000);
        x1 = fsolve(@CCE_fun,[0.65,0.65],options);  %����ţ�ٷ����  %���£���̼��̼ΪMole����
        %         fval
        xr = x1(1);
        xa = x1(2);
        jieguo1(i,j,1:4)=[phase1(i,2), phase1(i,3), xa, xr];
        %����ػ�������ά����
    end
end
%��ػ�����������Ms�¶�
C=jieguo1(:,:,4)*100;
Msr = 539-423*C-30.4*Mn-17.7*Ni-12.1*Cr-7.5*Mo;


%��ڶ��δ������ɵĸ����
phase2 = zeros(n,m);
finalphase = zeros(n,m);
for i=1:n%ÿһ������¶�
    for j=1:m%ÿһ���ػ��¶�
        %�ж��аµ���Ms�¶�
        if Msr(i,j)<roomT
            f2r=1;
        else
            f2r=exp(-1.1*10^(-2)*(Msr(i,j)-roomT));
        end
        phase2r=f2r*phase1(i,3);%���ղ��������
        phase2a=(1-f2r)*phase1(i,3); %����������
        phase2(i,j,1:2)=[phase2a,phase2r];
        finalphase(i,j,1:2)=[1-phase2r,phase2r];
    end
end
%�������м�����
FM = zeros(n,m,11);
for i=1:n%ÿһ������¶�
    for j=1:m%ÿһ���ػ��¶�
        %����¶�1����һ�δ��������2���а�3���ֵ�MS��4
        %�ػ��¶�5���ػ����������̼����6��������̼����7
        %�ڶ��δ��Ms��8��������������9�����������庬��10���аº���11
        FM(i,j,1:11)=[phase1(i,1:3),Ms,partT(j),jieguo1(i,j,3)*100,...
            jieguo1(i,j,4)*100,Msr(i,j),phase2(i,j,1),finalphase(i,j,1),finalphase(i,j,2)];
    end
    
end
hds = {'����¶�','��һ�δ��������','�а�', '�ֵ�MS��','�ػ��¶�5',...
    '�ػ����������̼����','������̼����','�ڶ��δ��Ms��','������������','���������庬��','�аº���'};
if length(qunchT) == length(partT)
    if sum(abs(qunchT - partT)) == 0
        fileN = 'һ��Q&P��ֵ�ⷨ.xlsx';
        values = num2cell([phase1(:,1:3),Ms*ones(length(phase1(:,1)),1),partT',...
            jieguo1(:,1,3)*100,jieguo1(:,1,4)*100,Msr(:,1),...
            phase2(:,1,1),finalphase(:,1,1),finalphase(:,1,2)]);
        xlswrite(fileN,[hds;values]);
    else
        fileN = '����Q&P��ֵ�ⷨ.xlsx';
        for k = 1:11
            xlswrite(fileN,FM(:,:,k),hds(k));
        end
    end
else
    fileN = '����Q&P��ֵ�ⷨ.xlsx';
    for k = 1:11
        xlswrite(fileN,FM(:,:,k),cell2mat(hds(k)));
    end
end

end