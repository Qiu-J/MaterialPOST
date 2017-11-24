function strainstress_sep(filename)
%����¥3¥�������ݷ������
% 1.����
%     ������������̫���������е㵰�ۣ���дһС�������ڷ������������������ݵķ��롣
% 2.�÷�
%     ��MATLAB���������strainstress_sep('��������excel�ļ�·��'��
%     ��strainstress_sep('E:\MATLAB\tool-self\test\��������.xlsx')
%    ��PS�����Խ������ļ�����MATLAB��ǰ·���Ϳ���ֻҪ�����ļ����Ϳ��ԣ�Ҫ����׺����
%     �磺strainstress_sep('��������.xlsx')
% 3.�����ݵ�Ҫ��
%     ������õ���������EXCEL �򿪣�ѡ�񶺺ŷָ�������Ϊ.xlsx�ļ�����
%     ������ֻҪ�����м��Կո�������ķָ����Ϳ��Է���
%���룺
%   filename�������������Ϊ��EXCEL�ļ��������ڵ�ǰ·���Ļ�ע��д����·��
%     ��strainstress_sep('E:\MATLAB\tool-self\test\��������.xlsx')

%% version 2.0
%   ÿһ��������ƣ���λ�����㵼��origin
%   �Ż����룬���ٲ���excel�Ĵ�������������ٶ�
%   ��Ʒ�ĸ���������
%   �޸ĺ�����Ϊstrainstress_sep
%% version 1.0
%   ʵ�ֻ������ܣ���������
%   ���㣺��β���EXCL�����������ҷ������Ʒ����������100������

%% ���ݶ�ȡ
a = xlsread(filename);
strastre = a(:,[3, 5]);%4��Ϊ����Ӧ��,��6��Ϊ����Ӧ��
[m, ~] = size(strastre);

%% ���ݶ������Լ���ʼ����λ�õ��±�
k1 = 1;
k2 = 1;
a1 = strastre(:,1); 
for k = 2:m
    if isnan(a1(k))&&(~isnan(a1(k+1)))
        ds(k1) = k + 1;%���ݿ�ʼλ�ã����ݿ�ʼ��λ�ñ����ݽ�����λ�ö�һ����
        k1 = k1+1;
    elseif isnan(a1(k))&&(~isnan(a1(k-1)))
        df(k2) = k-1;%���ݽ���λ��
        k2 = k2+1;
    else
    end
end
df(k2) = m; %�����һ��λ��һ���ǽ�����λ��
lenth_data = df - ds; %ÿһ�����ݵĳ���
m0 = max(lenth_data);
n0 = length(ds);%�����ݵ�

%%  ���ݵ�д��
data_out = nan(m0-1,2*n0);  %ע�⣬�õ������2�У���Ϊ���һ�о����쳣
for i = 1:n0
    data_out(1:(lenth_data(i)-1),(2*i-1):2*i) = strastre(ds(i):df(i)-2,:);
end
head1 = {'Ӧ��','Ӧ��';'%','MPa'};
head = repmat(head1,1,n0);
xlswrite(filename,head,'Sheet2','A1')
xlswrite(filename,data_out,'Sheet2','A3')

end
