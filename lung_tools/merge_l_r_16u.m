function [CT,SUPP] = merge_l_r_16u( CT_RIGHT , BB_RIGHT , ...
                                    CT_LEFT  , BB_LEFT , ...
                                    SUPP_ORIG , SUPP_SEG )

%
% [MERGED,SUPP] = merge_l_r( CT_RIGHT , BB_RIGHT , ...
% 	                         CT_LEFT  , BB_LEFT , ...
% 			                 SUPP, ...
%                            SUPP_ORIGINAL )
%
% Merge left and right segmented stacks into a full stack
%

% get dimensions from original
w = SUPP_ORIG.width;
h = SUPP_ORIG.height;
slices = SUPP_ORIG.n;

%GF20080505 (and 20080620 added tu lung_tools)
%cut unnecessary slices
%slices = SUPP_ORIG.n;
slices = max(BB_LEFT.z1,BB_RIGHT.z1) + 10;

% allocate output stack
CT = repmat( uint16(0) , [h w slices] );

% copy dimension data to output SUPP

SUPP        = SUPP_SEG;
SUPP.width  = SUPP_ORIG.width;
SUPP.height = SUPP_ORIG.height;
%GF20080505 (and 20080620 added tu lung_tools)
%SUPP.n      = SUPP_ORIG.n;
SUPP.n      = slices;

% copy right lung to MERGED
CT( BB_RIGHT.y0 + 1 : BB_RIGHT.y1 + 1 , ...
	BB_RIGHT.x0 + 1 : BB_RIGHT.x1 + 1 , ...
	BB_RIGHT.z0 + 1 : BB_RIGHT.z1 + 1 ) = CT_RIGHT;

% copy left lung to MERGED
% CT( BB_LEFT.y0 + 1 : BB_LEFT.y1 + 1 , ...
% 	BB_LEFT.x0 + 1 : BB_LEFT.x1 + 1 , ...
% 	BB_LEFT.z0 + 1 : BB_LEFT.z1 + 1 ) = CT_LEFT;

%merged from Riccardi version, otherwise we can blank nonzero pixels from
%right lung

% now find not-zero pixels in left image  
map = CT_LEFT>0;

for x = 1 : BB_LEFT.w
    for y = 1 : BB_LEFT.h
        for z = 1: BB_LEFT.z
            if map(y,x,z) > 0
                
               CT( BB_LEFT.y0 + y, BB_LEFT.x0 + x, 	BB_LEFT.z0 + z) = CT_LEFT (y,x,z); 
                
            end            
        end
    end
end



