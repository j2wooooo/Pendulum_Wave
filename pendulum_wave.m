%% Pendulum Wave Group Project

%% 초기 설정

t_n=0; % 시작시간
init_th=pi/3; % 초기 각도 60도
g = 9.8; % 중력가속도
r=2.1; % 구의 반지름 2.1cm
length = 30.1; % 제일 짧은 줄의 길이 30.1cm
f_max = 600; % 모든 줄이 동일선상으로 되돌아오는 최초의 시간
t = f_max; % 다시 처음의 상태로 돌아오기 위한 시간
a = 900; % 감쇠인자 실제 줄어드는 각도에 따라 조절, 줄이면 감쇠가 더 크게 된다.

x=zeros(1,15); % 15개 공의 x좌표를 넣을 행렬, x = [0 0 0, ...,0 0 0]
y=linspace(0,84,15); % 15개 공의 y좌표를 넣을 행렬 , y = [0 6 12, ...,72 78 84]  줄 간격 6cm
z=zeros(1,15); % 15개 공의 z좌표를 넣을 행렬, z = [0 0 0, ...,0 0 0]

%% 줄의 길이와 진동수 구하기

f(1) = 1/(2*pi*sqrt(length/g)); % 제일 짧은 줄의 길이의 진동수
for i = 2: 15 % 모든 진동수 값을 구한다
    f(i) = f(i-1)-(1/f_max); % 각 줄의 진동수를 1/600씩 차이나게 만든다.
    % 각 줄이 일정한 진동수로 차이가 나야 패턴이 만들어진다.
end

for i = 1:15 % 진동수 값에 따른 줄의 길이를 구한다
    lengths(i) = g/(4*(pi)^2*f(i)^2);
    % L = g/(4pi^2f^2)
    % 진동수에 따른 줄 길이를 넣어준다.
end

%% 초기 구현

 line([0 0],[-6 90],[0 0],'color',[0.8 0.7 0.7],'LineWidth',3); % 기준 막대
 hold on % 기준 막대는 항상 그려진다.
 
% 구를 만들 값
[X, Y, Z] = sphere;
% 구와 선을 그리기 위한 기초작업, 속도를 빠르게 하기 위한 객체 생성 작업
h=zeros(1,15); % 공의 정보를 담을 행렬
l=zeros(1,15); % 선의 정보를 담을 행렬
for j=1:15 % 15번 진행
    Xc = r*X + x(j); Yc = r*Y + y(j); Zc = r*Z + z(j); % surf 함수에 들어갈 값
    h(j)=surf(Xc, Yc, Zc); % 15개 공에 대한 정보가 담겨있는 객체
    l(j)=line([x(j),0],[y(j), y(j)],[z(j),0]); % 기준막대의 각 위치에서 공까지를 이은 줄에 대한 정보가 담겨있는 객체
end

% vidObj = VideoWriter('final_pendula_wave_left-back.avi'); % 비디오 제목을 정함 
% open(vidObj); % 비디오를 찍을 준비
% 움직이는 영상은 title
% title({'';'';'[INU] ESE LINEAR SYSTEM GROUP PROJECT'; '1-GROUP'},'FontSize',7);
% az = 0; el = 180; % 4번 view 주영
% az = 90; el = 180; % 5번 view 주영
az = 90; el = 30;
% 입체감을 주기 위한 밝기 조절
light('Position',[0 0 10],'Style','local','Color',[0.8 0.8 0.8]);

% 고정된 영상은 text
% text(73,0,32,'[INU] ESE LINEAR SYSTEM GROUP PROJECT','FontSize',7);
% text(28,0,27,'1-GROUP','FontSize',7);

%% 실제 구현

while (t>t_n) % 시간이 정해준 시간 간격으로 증가함에 따라 진행
    i=1:15;  % 구 15개에 대한 x,z 좌표값을 구한다
    x(i)=sin((1+init_th-(exp(t_n/a)))*cos(2*pi*f(i)*t_n)).*(lengths(i));
    z(i)=-cos((1+init_th-(exp(t_n/a)))*cos(2*pi*f(i)*t_n)).*(lengths(i));
    % t=0일 때 x,y 모두 최댓값을 갖는 주기운동을 해야 하므로, cos(2*pi*f*t)로 시간이 지남에 따라 움직인다.
    % 감쇠하는 운동을 구현하기 위해 init_th 가 아닌 (1+init_th-(exp(t_n/a)))를 곱하여 각도를 줄여 주었다.
    
    for j=1:15
        shading interp; % 구의 표면 선을 지워줌
        Xc = r*X + x(j); Yc = r*Y + y(j); Zc = r*Z + z(j);
        set(h(j), 'XData', Xc, 'YData', Yc, 'ZData', Zc); % 구 속성 설정
        % 구에 따른 선 속성 설정
        set(l(j), 'XData', [x(j) 0], 'YData', [y(j) y(j)] ,'ZData', [z(j) 0],'color',[0.8 0.8 0.8],'LineWidth',0.3);
        % 배경 색은 흰색으로 한다
        set(gcf,'color','w');
        % 격자무늬를 지운다
        grid off;
    end
    xlabel('X');ylabel('Y');zlabel('Z'); % 각 축의 라벨 axis off 하면 사라짐

%% 1번 VIEW

%     view(0,10) % 앞에서 봤을 때
%     axis([-70 70 -20 100 -80 30]); % 각 축의 범위를 정한다

%% 2번 VIEW

%    view(0,90); % 위에서 봤을 때
%    axis([-70 70 -20 100 -80 30]); % 각 축의 범위를 정한다

%% 3번 view

%  view(210,--20); % 왼쪽 대각선에서 봤을 때
%  axis([-70 70 -20 100 -90 50]); % 각 축의 범위를 정한다

%% 4번 view

%     if el < 90; mode = -1; end
%     if el > 270; mode = 1; end
%     el = el + mode;
%     
%     view(90, el);
%     axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

%% 5번 view - 주영

%     if az == 90; mode = 1; end
%     if az == 270; mode = -1; end
%     az = az + mode;
%     
%     view(az, 30);
%     axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다
 
%% 6번 VIEW - 지우

%     if t_n < t/6
%       view(0,10+480*(t_n/t));
%       el1 = 10+480*(t_n/t);
%     elseif t/6 <= t_n && t_n < 2*t/6
%         view((720/t)*(t_n-t/6)+1,el1);
%         az1 = (720/t)*(t_n-t/6)+1;
%     elseif 2*t<6 <= t_n && t_n < 3*t/6
%         view((720/t)*(t_n-t/6)+1,el1-(1080/t)*(t_n-2*t/6));
%         az2 = (720/t)*(t_n-t/6)+1;
%         el2 = (el1-(1080/t)*(t_n-2*t/6));
%     elseif 3*t/6 <= t_n && t_n < 4*t/6
%         view(az2+((720/t)*(t_n-3*t/6)+1),el2+(1080/t)*(t_n-3*t/6));
%         az3 = az2+((720/t)*(t_n-3*t/6)+1);
%         el3 = el2+(1080/t)*(t_n-3*t/6);
%     elseif 4*t/6 <= t_n && t_n < 5*t/6
%         view(az3,el3-(540/t)*(t_n-4*t/6));
%         el4 = el3-(540/t)*(t_n-4*t/6);
%     elseif 5*t/6 <= t_n && t_n < t 
%         view(az3,el4);
%         view(az3,el4+(540/t)*(t_n-5*t/6));
%     end
% 
% axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

% %% 7번 VIEW - 지우
% 
%        init_vpoint = [60,60,90]; % 시점 변경 전 내가 바라보는 시점의 초기 좌표
%        
%        if t_n <= 100 
%            rot1 = [cos(t_n*pi/50) -sin(t_n*pi/50) 0; sin(t_n*pi/50) cos(t_n*pi/50) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos((-t_n*pi)/180) 0 -sin((-t_n*pi)/180); 0 1 0; sin((-t_n*pi)/180) 0 cos((-t_n*pi)/180)]; % 시계 방향 pitch 회전
%            rot = rot1*rot2;
%            rot_1 = rot;
%        elseif t_n > 100 && t_n <= 180
%            disp('start2');
%            rot1 = [cos((t_n-100)*pi/90) sin((t_n-100)*pi/90) 0; -sin((t_n-100)*pi/90) cos((t_n-100)*pi/90) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos((t_n-100)*pi/180) 0 sin((t_n-100)*pi/180); 0 1 0; -sin((t_n-100)*pi/180) 0 cos((t_n-100)*pi/180)]; % 반시계 방향 roll 회전
%            rot = rot_1*rot1*rot2;
%            rot_2 = rot;
%        elseif t_n > 180 && t_n <= 270
%            %disp('start3')
%            rot1 = [cos((t_n-180)*pi/180) -sin((t_n-180)*pi/180) 0; sin((t_n-180)*pi/180) cos((t_n-180)*pi/180) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos((-(t_n-180)*pi)/180) sin((-(t_n-180)*pi)/180) 0; -sin((-(t_n-180)*pi)/180) cos((-(t_n-180)*pi)/180) 0; 0 0 1]; % 시계 방향 pitch 회전
%            % 각도에 -를 넣어 반대방향으로 회전하게 만듬
%            rot = rot_2*rot1*rot2;
%            rot_1 = rot;
%         elseif t_n > 270 && t_n <= 360
%            disp('start3')
%            rot1 = [cos((t_n-270)*pi/50) sin((t_n-270)*pi/50) 0; -sin((t_n-270)*pi/50) cos((t_n-270)*pi/50) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos((-(t_n-270)*pi)/180) 0 sin((-(t_n-270)*pi)/180); 0 1 0; -sin((-(t_n-270)*pi)/180) 0 cos((-(t_n-270)*pi)/180)]; % 시계 방향 pitch 회전
%            % 각도에 -를 넣어 반대방향으로 회전하게 만듬
%            rot = rot_1*rot1*rot2;
%            rot_2 = rot;
%         elseif t_n > 360 && t_n <= 450
%            disp('start3')
%            rot1 = [cos((t_n-360)*pi/180) sin((t_n-360)*pi/180) 0; -sin((t_n-360)*pi/180) cos((t_n-360)*pi/180) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos(((t_n-360)*pi)/50) 0 sin(((t_n-360)*pi)/50); 0 1 0; -sin(((t_n-360)*pi)/50) 0 cos(((t_n-360)*pi)/50)]; % 시계 방향 pitch 회전
%            % 각도에 -를 넣어 반대방향으로 회전하게 만듬
%            rot = rot_2*rot1*rot2;
%            rot_1 = rot;
%         elseif t_n > 450 && t_n <= 540
%            disp('start3')
%            rot1 = [cos((t_n-450)*pi/180) sin((t_n-450)*pi/180) 0; -sin((t_n-450)*pi/180) cos((t_n-450)*pi/180) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos((-(t_n-450)*pi)/180) 0 sin((-(t_n-450)*pi)/180); 0 1 0; -sin((-(t_n-450)*pi)/180) 0 cos((-(t_n-450)*pi)/180)]; % 시계 방향 pitch 회전
%            % 각도에 -를 넣어 반대방향으로 회전하게 만듬
%            rot = rot_1*rot1*rot2;
%            rot_2 = rot;
%        elseif t_n > 540
%            disp('start3')
%            rot1 = [cos((t_n-540)*pi/180) sin((t_n-540)*pi/180) 0; -sin((t_n-540)*pi/180) cos((t_n-540)*pi/180) 0; 0 0 1]; % 시계 방향 yaw 회전
%            rot2 = [cos((-(t_n-540)*pi)/180) 0 sin((-(t_n-540)*pi)/180); 0 1 0; -sin((-(t_n-540)*pi)/180) 0 cos((-(t_n-540)*pi)/180)]; % 시계 방향 pitch 회전
%            % 각도에 -를 넣어 반대방향으로 회전하게 만듬
%            rot = rot_2*rot1*rot2;
%        end
%        view_point = rot*init_vpoint'; % 내가 바라보는 시점을 회전시켜준다.
%        view([view_point(1),view_point(2),view_point(3)]); % 회전시킨 시점으로 화면을 바라본다.
% 
%        axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

%% 8번 상익

view(0+180*(t_n/t), 10); % 360도 회전 끝날때까지
axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

%% 9

% el = 30;
% view(az,30+el*-cos(t_n/10));
% az=az+1;
% axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

%% 10
% azm = mod(az,360);
% if azm < 40
%     az = az+8;
%     view(az,el);
% elseif azm >= 40 && azm < 140
%     az = az+1;
%     view(az,el);
% elseif azm >= 140 && azm < 220
%         az=az+8;
%         view(az,el);
% elseif azm >= 220 && azm < 320
%     az = az + 1;
%     view(az,el);
% elseif azm >= 320 && azm < 360
%     az = az+8;
%     view(az,el);
% end
% 
% axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

%% 11

%     if t_n < t/6
%       view(0,10+480*(t_n/t));
%       el1 = 10+480*(t_n/t);
% %       zoom on
%       camzoom(1.005);
%     elseif t/6 <= t_n && t_n < 2*t/6
%         view((720/t)*(t_n-t/6)+1,el1);
%         az1 = (720/t)*(t_n-t/6)+1;
%         camzoom(0.995);
%     elseif 2*t/6 <= t_n && t_n < 3*t/6
%         view((720/t)*(t_n-t/6)+1,el1-(1080/t)*(t_n-2*t/6));
%         az2 = (720/t)*(t_n-t/6)+1;
%         el2 = (el1-(1080/t)*(t_n-2*t/6));
%         if(5*t/12 < t_n)
%             camzoom(1.018);
%         else
%             camzoom(0.99);
%         end
%     elseif 3*t/6 <= t_n && t_n < 4*t/6
%         view(az2+((720/t)*(t_n-3*t/6)+1),el2+(1080/t)*(t_n-3*t/6));
%         az3 = az2+((720/t)*(t_n-3*t/6)+1);
%         el3 = el2+(1080/t)*(t_n-3*t/6);
%     elseif 4*t/6 <= t_n && t_n < 5*t/6
%         view(az3,el3-(540/t)*2*(t_n-4*t/6));
%         el4 = el3-(540/t)*2*(t_n-4*t/6);
%     elseif 5*t/6 <= t_n && t_n < t 
%         view(az3,el4);
%         view(az3,el4+(540/t)*(t_n-5*t/6));
%         if(11*t/12 < t_n)
%             camzoom(1.018);
%         else
%             camzoom(0.99);
%         end
%     end

% axis([-60 60 -10 100 -80 20]); % 각 축의 범위를 정한다

%% 공통 구현 부분

    axis off; % 축을 지운다 - 영상을 찍을 때 이 부분을 활성화 해야함
    axis square; % 정사각형으로 표준화하여 보여준다
    drawnow; % 그림을 그린다 빠르고 부드러운 영상을 그려줌
    
    t_n=t_n+1; %짧은 시간동안의 값을 계산하여 보여준다  - matlab으로 보았을 때의 실제 구현과 가장 근접한 시간 간격
    
%      currFrame = getframe; % 비디오 프레임
%      writeVideo(vidObj,currFrame) % 비디오 촬영
%     t_n=t_n+1/3.4; %짧은 시간동안의 값을 계산하여 보여준다 - 비디오 찍을 때의 실제구현과 가장 근접한 시간 간격
end
% close(vidObj); % 모든 구현이 끝나면 비디오 촬영을 종료
