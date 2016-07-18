function [Y] = vl_nnSP(inputs, dzdy)
	BLOBS = inputs{1};
	SEGS  = inputs{2};
    M = max(SEGS(:));
	size_ = size(BLOBS);
    
    BLOBSP = permute(BLOBS, [1,2,4,3]);
    B2 = reshape(BLOBSP, size_(1)*size_(2), size_(4),11);
    
	if nargin < 2
        Y = B2*0;

        for i=1:size(BLOBS,4)
            for s=0:max(max(SEGS(:,:,i)))
                idx = (SEGS(:,:,i) == s);
                a = B2(idx(:),i,:);
                mean_ = squeeze(mean(a))';
                Y(idx(:), i, :) = repmat(mean_, sum(idx(:)), 1, 1);
            end
        end
        
        Y = reshape(Y, size_(1), size_(2), size_(4), 11);
        Y = permute(Y, [1,2,4,3]);
	else 
		Y = cell(1, 2);
        G = 1 + B2*0;
        
        for i=1:size(BLOBS,4)
            for s=0:max(max(SEGS(:,:,i)))
                idx = (SEGS(:,:,i) == s);
                G(idx(:), i, :) = 1/sum(idx(:));
            end
        end
        
        G = reshape(G, size_(1), size_(2), size_(4), 11);
        G = permute(G, [1,2,4,3]);
        Y{1} = G.*dzdy;
	end
end

