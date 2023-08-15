# Coliseum-Smart-Contracts
Smarts Contracts Repo

  function _beforeTokenTransfer(
          address from,
          address to,
          uint256 tokenId,
          uint256 /** batch **/
      ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId, 1);

      if (from != to && _users[tokenId].user != address(0)) {
      delete _users[tokenId];
      emit UpdateUser(tokenId, address(0), 0);
    }
  }