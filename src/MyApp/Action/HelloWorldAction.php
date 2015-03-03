<?php
namespace MyApp\Action;

use MyApp\Responder\DefaultResponder;

class HelloWorldAction
{
    use \Adore\ActionTrait;

    public function __invoke()
    {
        $responder = $this->_getResponder('default');
        $responder->setData("Hello Docker Austin!");
        return $responder;
    }
}