<?php
namespace MyApp\Action;

use MyApp\Responder\DefaultResponder;

class HelloWorld
{
    use \Adore\ActionTrait;

    public function hello()
    {
        $responder = new DefaultResponder();
        $responder->setData("Hello World!");
    }
}