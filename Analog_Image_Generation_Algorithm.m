%选择输入的图像路径
selpath = uigetdir('polyps');
if ~isequal(selpath,0)
    pathname_old=selpath;
    %app.foldnameEditField.Value=selpath;
else 
     warndlg('selpath fail','Warning');
    return
end

%选择输出的图像路径
selpath = uigetdir('honeycombpolyp');
if ~isequal(selpath,0)
    pathname_new=selpath;
    %app.foldnameEditField.Value=selpath;
else 
     warndlg('selpath fail','Warning');
    return
end

%%批量读取，处理，并输出
fileList=dir(fullfile(pathname_old,'*.jpg'));
nn=length(fileList); 

for ii=1:nn
    filename_old=fileList(ii).name; 
    filename_new=strcat(filename_old(1:end-4),"_processed",".jpg");
    image=imread(fullfile(pathname_old,filename_old));

% 定义蜂窝图案参数
radius = 3; % 六边形的半径
num_rows = 240; % 六边形的行数
num_cols = 300; % 六边形的列数
spacing = 2; % 六边形之间的间距

% 计算六边形的几何参数
height = sqrt(3) * radius;
width = 2 * radius;
x_offset = spacing + width * 3 / 4;
y_offset = spacing + height;

% 创建新图像，与原始图像大小相同
[h, w, ~] = size(image);
new_image = zeros(h, w, 'uint8'); % 使用单通道图像，只保留灰度信息

% 绘制六边形图案并将六边形区域填充为白色
for i = 1:num_rows
    for j = 1:num_cols
        x = (j - 1) * x_offset;
        y = (i - 1) * y_offset;
        if mod(j, 2) == 0
            y = y + y_offset / 2;
        end
        hex_x = x + radius * cosd(0:60:360);
        hex_y = y + radius * sind(0:60:360);
        mask = poly2mask(hex_x, hex_y, h, w);
        new_image = new_image | uint8(mask * 255); % 将六边形区域填充为白色
    end
end

% 将原始图像的不感兴趣的区域颜色变浅
black_mask = new_image == 0;
image(black_mask) = uint8(double(image(black_mask)) * 0.5); % 将黑色区域变为浅黑色

 pathfilename_new=fullfile(pathname_new,filename_new);
 imwrite(image,pathfilename_new);
 
end


disp("ok~");

