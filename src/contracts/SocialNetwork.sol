pragma solidity ^0.5.0;

contract SocialNetwork {
  string public name;

  uint public postCount = 0;

  mapping(uint => Post) public posts;

  struct Post {
    uint id;
    string content;
    uint tipAmount;
    address payable author;
  }

  event postCreated(
    uint id,
    string content,
    uint tipAmount,
    address payable author
  );

   event postTipped(
    uint id,
    string content,
    uint tipAmount,
    address payable author
  );

  constructor() public {
    name = "Dapp University Social Network";
  }
   function createPost(string memory _content) public {
      //validate the content string
      require(bytes(_content).length > 0, "invalid content");
      //increment post count
      postCount ++;
      // add post to the blockchain
      posts[postCount] = Post(postCount, _content, 0,msg.sender);
      // trigger event
      emit postCreated(postCount, _content, 0, msg.sender);
   }

   function tipPost(uint _id) public payable{
     // check id
     require(_id > 0 && _id <= postCount, "Invalid Id");
     // fetch the post
     Post memory _post = posts[_id];
     //fetch author 
     address payable _author = _post.author;
     // pay the author
     address(_author).transfer(msg.value);
     // increment the tipAmount of the post
     _post.tipAmount = _post.tipAmount + msg.value;
     // update the post
     posts[_id] = _post;
     // trigger an event
      emit postTipped(postCount,_post.content, _post.tipAmount, _author );
   }
}