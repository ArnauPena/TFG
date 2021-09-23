classdef ConnectionMatrix < handle
    
    properties
        dim
        data
        td
    end
    
    methods (Access = public)
        function obj = ConnectionMatrix(cParams)
                obj.loadData(cParams);
        end
        
        function obj = loadData(obj,cParams)
            obj.dim = cParams.dim;
            obj.data = cParams.data;
        end
        
    end
    methods (Access = public)
        function obj = computeConnectionMatrix(obj)
            nel = obj.dim.nel;
            ni = obj.dim.ni;
            nne = obj.dim.nne;
            vtd = zeros(nel,nne*ni);
            for e = 1:nel
                for i = 1:nne
                    for j = 1:ni
                        I = ni*(i-1)+j;
                        vtd(e,I)= ni*(obj.data.Tnod(e,i)-1)+j;
                    end
                end
            end
            obj.td = vtd;
        end
    end
end

