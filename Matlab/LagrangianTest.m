function [lcx,lcy,lux,luy]=LagrangianTest(ux,vy,gx,gy)
% [lcx,lcy,lux,luy]=LagrangianTest(UU,VV,gx,gy)
% ??Adams-Bashforth??????????????
% ??
% UU ????u
% VV ????v
% gx ????x
% gy ????y
% ??
% lcx ??????x
% lcy ??????y
% lux ????????x
% luy ????????y

tic
if nargin==0 %??????????????????
    load ./mat/Two001.mat %??????????????
end

mx=linspace(0,217,84);%????????
[mx,my]=meshgrid(mx,mx);
dt=1/40;%??????
NT=size(ux,3);%???????


%???????????4
if nargin~=4
    Np=2500;
    
    gx=rand(1,Np)*217;%???????????
    gy=rand(1,Np)*217;
end
gx=reshape(gx,[],1);
gy=reshape(gy,[],1);

if nargin==4 %????????
    xi=find(isnan(gx.*gy)==0);%??NaN?
    gx=gx(xi);
    gy=gy(xi);
end

Np=size(gx,1);
lcx=zeros(NT,Np)*nan;%???????
lcy=zeros(NT,Np)*nan;
lux=lcx; %???????
luy=lcx;


lcx(1,:)=gx;
lcy(1,:)=gy;
tlcx=gx;
tlcy=gy;

u=squeeze(ux(:,:,1)); %???????
v=squeeze(vy(:,:,1));
tu=interp2(mx,my,u,tlcx,tlcy,'spline');%???????
tv=interp2(mx,my,v,tlcx,tlcy,'spline');
lux(1,:)=tu;
luy(1,:)=tv;
tu0=tu;
tv0=tv;
for i=2:NT %????
    
    u=squeeze(ux(:,:,i));% 
    v=squeeze(vy(:,:,i));
    
    
    tu=interp2(mx,my,u,tlcx,tlcy,'spline');%
    tv=interp2(mx,my,v,tlcx,tlcy,'spline');
    
    % AB ????????
    
    tlcx=(3*tu-tu0)*dt*0.5+tlcx; 
    tlcy=(3*tv-tv0)*dt*0.5+tlcy;
    
    
    
    tlcx(tlcx<0)=nan;%??????????
    tlcx(tlcx>217)=nan;
    
    tlcy(tlcy<0)=nan;
    tlcy(tlcy>217)=nan;
    
    lcx(i,:)=tlcx;%????
    lcy(i,:)=tlcy;
    
    tu=interp2(mx,my,u,tlcx,tlcy,'spline');%????
    tv=interp2(mx,my,v,tlcx,tlcy,'spline');
    
    tu(abs(tu)>3)=nan;%???????
    tv(abs(tv)>3)=nan;
    
    tu0=tu;%
    tv0=tv;
    
    lux(i,:)=tu;%????
    Mu=max(tu);
    if Mu>100
        i
    end
    luy(i,:)=tv;
    if mod(i,100)==0
        i
        toc
    end
    
end

