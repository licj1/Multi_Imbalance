% Reference:	
% Name: classOVA.m
% 
% Purpose: a classification algorithm (originally designed) for binary imbalanced data.
% 
% Authors: Chongsheng Zhang <chongsheng DOT Zhang AT yahoo DOT com>
% 
% Copyright: (c) 2018 Chongsheng Zhang <chongsheng DOT Zhang AT yahoo DOT com>
% 
% This file is a part of Multi_Imbalance software, a software package for multi-class Imbalance learning. 
% 
% Multi_Imbalance software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License 
% as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
%
% Multi_Imbalance software is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with this program. 
% If not, see <http://www.gnu.org/licenses/>.
function [trainTime,testTime,prelabel] = classOVA(traindata,trainlabel,testdata)
tic;
labels = unique (trainlabel);
numberc=length(labels);
code=zeros(numberc,numberc);
code(:,:)=-1;
for i=1:numberc
    code(i,i)=1;
end
for i=1:numberc
    idi=(trainlabel==labels(i));
    train{i}=traindata(idi,:);
    numbern(i)=length(trainlabel(idi));
end
numberl=numberc;
for t=1:numberl
    Dt=[];
    Dtlabel=[];
    flagDt=0;
    numberAp=0;
    numberAn=0;
    numberNp=0;
    numberNn=0;
    for i=1:numberc
        if code(i,t)==1
            Dt=[Dt;train{i}];
            Dtlabel(flagDt+1:flagDt+numbern(i))=1;
            flagDt=flagDt+numbern(i);
            numberAp=numberAp+1;
            numberNp=numberNp+numbern(i);
        elseif code(i,t)==-1
            Dt=[Dt;train{i}];
            Dtlabel(flagDt+1:flagDt+numbern(i))=-1;
            flagDt=flagDt+numbern(i);
            numberAn=numberAn+1;
            numberNn=numberNn+numbern(i);
        end
    end
   pre{t} = multiIMCart(Dt,Dtlabel',testdata);
end
trainTime=toc;

tic;
numbertest=size(testdata,1);
numberC=size(code,1);
allpre=zeros(numbertest,numberC);
for t=1:length(pre)
    allpre(:,t)=pre{t};
end

for i=1:numbertest
    ftx=allpre(i,:);
    
    for r=1:numberC
        for t=1:length(ftx)
            btr(t)=(1-ftx(t)*code(r,t))/2;
        end
        yall(r)=sum(btr);
    end

    [minval,minindex]=min(yall);
    prelabel(i)=labels(minindex);
end

prelabel=prelabel';
testTime=toc;
