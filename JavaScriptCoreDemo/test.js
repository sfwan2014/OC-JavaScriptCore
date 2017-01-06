var factorial = function(n) {
    
    if (n < 0)
        
        return;
    
    if (n === 0)
        
        return 1;
    
    return n * factorial(n - 1)
    
};

var function1 = function(value){
    var element = document.getElementById("element1");
    element.innerHTML = value;
};

var function2 = function(value){
    var element = document.getElementById("element2");
    element.innerHTML = value;
    return 10;
}

var function3 = function(value){
    var element = document.getElementById("element3");
    element.innerHTML = value;
}
