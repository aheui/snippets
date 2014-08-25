var table = [
	"바", "받반타", "반", "받", "밤",
	"발", "밦", "밝", "밣", "밢","반발따"
];

function factorization( a )
{
	var primes = [];
	var factor = 2;
	var sqrt = Math.floor( Math.sqrt( a ) );
	if( a<2 ) return [ a ];
	while( a>1 )
	{
		if( sqrt<factor ){
			primes.push(a);
			break;
		}
		if( a%factor ){
			++factor;
			continue;
		}
		primes.push( factor );
		a = Math.floor( a/factor );
	}
	return primes;
}

function compressFactors( a )
{
	var cnt2 = 0;
	var cnt3 = 0;
	var result = [];
	for( var i=0; i<a.length; ++i )
	{
		if( a[ i ]==2 )
		{
			++cnt2;
			if( !( cnt2%3 ) ) result.push( 8 );
		} else if( a[ i ]==3 )
		{
			++cnt3;
			if( !( cnt3%2 ) ) result.push( 9 );
		} else result.push( a[ i ] );
	}
	if( cnt2%3==2 ) result.push( 4 );
	if( cnt2%3==1 && cnt3%2==1) result.push( 6 );
	else if( cnt3%2==1 ) result.push( 3 );
	else if( cnt2%3==1 ) result.push( 2 );
	return result;
}

function isPrime( a )
{
	var sqrt = Math.floor( Math.sqrt( a ) );
	if( a<2 ) return false;
	for( var i=2; a%i&&i<=sqrt; ++i );
	return sqrt+1 == i;
}

function n2Aheui3( a )
{
	var i;
	for(i=9; a/i<10; --i){
		if(!(a%i)){
			return table[i]+table[a/i]+"따";
		}
	}
	return "";
}

function number2Aheui( a )
{
	var i;
	var result = "";
	var divided;
	var compressed;
	var tmp;

	if( a<82 ){
		if( a<11 ) return table[ a ];
		if( a<20 ) return table[9]+table[a-9]+"다";
		if(tmp=n2Aheui3(a)){
			return tmp;
		}else{
			tmp=a%9;
			if(tmp==1) return n2Aheui3(a+8)+table[8]+"타";
			else return n2Aheui3(a-tmp)+table[tmp]+"다";
		}
	}

	if( isPrime( a ) ) return number2Aheui(Math.floor( a/9 ))+table[9]+"따"+table[a%9]+"다";
	else {
		compressed = compressFactors( factorization( a ) );
		tmp=compressed.length;
		for( i=0; i<tmp; ++i )
			result += number2Aheui( compressed[ i ] );
		--tmp;
		for( i=0; i<tmp; ++i )
			result += "따";
		return result;
	}
}

function number2AheuiQ( a )
{
	var i;
	var tmp;
	var result = "";

	if( a<11 ) return table[ a ];
	var _9=[];
	while(a){
		_9.push(Math.floor(a%9));
		a=Math.floor(a/9);
	}
	i=_9.length;
	while(i--){
		if(tmp =_9[i]){
			if(i==_9.length-1){
				result+=table[tmp];
			}else{
				result+=table[9]+"따"+table[tmp]+"다";
			}
		}else{
			result+=table[9]+"따";
		}
	}
	return result;
}

function trace2Aheui( a )
{
	var result = "";
	for( var i=0; i<a.length; ++i )
		result += number2Aheui( a.charCodeAt( i ) )+"맣";
	return result;
}

function trace2AheuiQ( a )
{
	var result = "";
	for( var i=0; i<a.length; ++i )
		result += number2AheuiQ( a.charCodeAt( i ) )+"맣";
	return result;
}