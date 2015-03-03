<?php

$app = new Adore\Application;

$app->setActionFactory(function($actionName) {
    $properActionName = ucfirst($actionName) . "Action";
    $className = "\\MyApp\\Action\\$properActionName";
    return new $className;
});

$app->setResponderFactory(function($responderName) {
    $properResponderName = ucfirst($responderName) . "Responder";
    $className = "\\MyApp\\Responder\\$properResponderName";
    return new $className;
});

$app->addRoute("/", "HelloWorld");


$app->run();