<?php
namespace MyApp\Responder;

class DefaultResponder
{
    use \Adore\ResponderTrait;

    protected $data;

    public function setData($data)
    {
        $this->data = $data;
    }

    public function __invoke()
    {
        $this->_response->content->set($this->data);

    }
}