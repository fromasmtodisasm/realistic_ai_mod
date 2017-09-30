MethodDispatcherPool={
	_pool={},
};

function MethodDispatcherPool:AddObj(obj,idx)
	local _idx=obj;
	if(idx)then
		_idx=idx;
	end
	self._pool[_idx]=obj;
end

function MethodDispatcherPool:RemoveObject(idx)
	self._pool[idx]=nil;
end

function MethodDispatcherPool:Exists(idx)
	return self._pool[idx];
end

function MethodDispatcherPool.IndexHandler(table,index)
	local f = function(...)
		local pool=%table._pool
		for i,val in pool do
			local pool_func=val[%index];
			if(pool_func)then
				arg[1]=val;
				call(pool_func,arg);
			end
		end
	end
	table[index]=f;
	return f;
end

function MethodDispatcherPool:new()
	local mmp=new(MethodDispatcherPool);
	local tag=newtag()
	settagmethod(tag,"index",MethodDispatcherPool.IndexHandler);
	settag(mmp,tag);
	return mmp;
end
